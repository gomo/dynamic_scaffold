module DynamicScaffold
  module ControllerUtilities
    private

      # Get the hash of the key and value specified for the scope.
      def scope_params
        return {} if dynamic_scaffold.scope.nil?
        case dynamic_scaffold.scope
        when Array then
          dynamic_scaffold.scope.each_with_object({}) do |val, res|
            if val.is_a? Hash
              val.each {|k, v| res[k] = v}
            else
              res[val] = params[val]
            end
          end
        when Hash then
          dynamic_scaffold.scope
        end
      end

      # Convert pkey_string value to hash.
      def pkey_string_to_hash(pkey)
        # https://github.com/gomo/dynamic_scaffold/pull/9/commits/ff5de0e38b3544347e82539c45ffd2efaf3410da
        # Stop support multiple pkey, on this commit.
        # Convert "key:1,code:foo" to {key: "1", code: "foo"}
        pkey.split(',').map {|v| v.split(':') }.each_with_object({}) {|v, res| res[v.first] = v.last }
      end

      # Get parameters for edit action. `key[column] => value`
      def edit_params
        params.permit(*dynamic_scaffold.model.primary_key)
      end

      # Get paramters for sort action. `pkeys[][column] => value`
      def sort_params
        params
          .require('pkeys')
          .map {|p| p.permit(*dynamic_scaffold.model.primary_key) }
      end

      # Get paramters for update record.
      def update_values
        permitting = dynamic_scaffold.form.items
                       .map(&:strong_parameter)
                       .concat(dynamic_scaffold.form.permit_params)
                       .flatten
        values = params
                   .require(dynamic_scaffold.model.name.underscore)
                   .permit(*permitting)

        if dynamic_scaffold.scope && !valid_for_scope?(values)
          raise DynamicScaffold::Error::InvalidOperation, "You can update only to #{scope_params} on this scope"
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
        if dynamic_scaffold.list.sorter_direction == :asc
          @sequence = 0
        elsif dynamic_scaffold.list.sorter_direction == :desc
          @sequence = record_count - 1
        end
      end

      def next_sequence!
        val = @sequence
        if dynamic_scaffold.list.sorter_direction == :asc
          @sequence += 1
        elsif dynamic_scaffold.list.sorter_direction == :desc
          @sequence -= 1
        end
        val
      end

      def find_record(params)
        rec = dynamic_scaffold.model.find_by(params.merge(scope_params))
        raise ::ActiveRecord::RecordNotFound if rec.nil?
        rec
      end

      def dynamic_scaffold_path(action, options = {})
        route = Rails.application.routes.routes.find do |r|
          route_params = r.required_defaults
          route_params[:controller] == params[:controller] && (route_params[:action] == action.to_s && r.name)
        end

        if route.nil?
          raise DynamicScaffold::Error::RouteNotFound,
            "Missing controller#action #{params[:controller]}##{action}"
        end

        options.merge!(scope_params)

        public_send("#{route.name}_path", options)
      end

      def dynamic_scaffold_icon(name)
        view_context.instance_exec name, &::Rails.application.config.dynamic_scaffold.icons
      end

      def primary_key_value(record)
        [*record.class.primary_key].each_with_object({}) {|col, res| res[col] = record[col] }
      end

      def bind_sorter_value(record)
        attr = dynamic_scaffold.list.sorter_attribute
        value = dynamic_scaffold.model.maximum(attr)
        record[attr] = value ? value + 1 : 0
      end

      def request_queries(*except)
        request.query_parameters.to_hash.delete_if {|k, _v| except.select(&:present?).include?(k.to_sym) }
      end

      def check_max_count!
        return if dynamic_scaffold.max_count.nil?
        instance_exec(@record, &dynamic_scaffold.lock_before_count) if dynamic_scaffold.lock_before_count
        count_query = dynamic_scaffold.list.build_sql(scope_params)
        count_query = count_query.lock if dynamic_scaffold.max_count_options[:lock]
        count = count_query.count
        raise Error::InvalidOperation, 'You can not add any more.' if dynamic_scaffold.max_count?(count)
      end
  end
end
