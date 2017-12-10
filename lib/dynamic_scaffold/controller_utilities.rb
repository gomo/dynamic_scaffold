module DynamicScaffold
  module ControllerUtilities
    private

      # Get the hash of the key and value specified for the scope.
      def scope_params
        return {} if self.class.dynamic_scaffold_config.scope.nil?
        self.class.dynamic_scaffold_config.scope.each_with_object({}) {|attr, res| res[attr] = params[attr] }
      end

      # Get the primary key hash from the update parameters.
      def extract_pkeys(values)
        [*self.class.dynamic_scaffold_config.model.primary_key].each_with_object({}) {|col, res| res[col] = values[col] }
      end

      # Convert pkey_string value to hash.
      def pkey_string_to_hash(pkey)
        # Support multiple pkey
        # Convert "key:1,code:foo" to {key: "1", code: "foo"}
        pkey.split(',').map {|v| v.split(':') }.each_with_object({}) {|v, res| res[v.first] = v.last }
      end

      # Get parameters for edit action. `key[column] => value`
      def edit_params
        params
          .require('key')
          .permit(*self.class.dynamic_scaffold_config.model.primary_key)
      end

      # Get paramters for sort action. `pkeys[][column] => value`
      def sort_params
        params
          .require('pkeys')
          .map {|p| p.permit(*self.class.dynamic_scaffold_config.model.primary_key) }
      end

      # Get paramters for update record.
      def update_values
        values = params
                 .require(self.class.dynamic_scaffold_config.model.name.underscore)
                 .permit(*self.class.dynamic_scaffold_config.form.fields.map(&:strong_parameter))

        if self.class.dynamic_scaffold_config.scope && !valid_for_scope?(values)
          raise DynamicScaffold::Error::InvalidParameter, "You can update only to #{scope_params} on this scope"
        end

        values
      end

      # Check if there are inconsistent scopes in update parameters
      def valid_for_scope?(update_params)
        result = true
        scope_params.each do |key, value|
          if update_params.key?(key) && update_params[key] != value
            result = false
            break
          end
        end
        result
      end

      def reset_sequence(record_count)
        if self.class.dynamic_scaffold_config.list.sorter_direction == :asc
          @sequence = 0
        elsif self.class.dynamic_scaffold_config.list.sorter_direction == :desc
          @sequence = record_count - 1
        end
      end

      def next_sequence!
        val = @sequence
        if self.class.dynamic_scaffold_config.list.sorter_direction == :asc
          @sequence += 1
        elsif self.class.dynamic_scaffold_config.list.sorter_direction == :desc
          @sequence -= 1
        end
        val
      end

      def find_record(params)
        rec = self.class.dynamic_scaffold_config.model.find_by(params.merge(scope_params))
        raise ::ActiveRecord::RecordNotFound if rec.nil?
        rec
      end

      def begin_transaction
        self.class.dynamic_scaffold_config.model.transaction do
          yield
        end
      end

      def callbacks(page, target, record, prev_attributes)
        self.class.dynamic_scaffold_config.public_send(page)
          .callbacks(target, self, record, prev_attributes)
      end
  end
end
