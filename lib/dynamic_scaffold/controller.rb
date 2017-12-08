module DynamicScaffold
  module Controller
    extend ActiveSupport::Concern

    class_methods do
      attr_accessor :dynamic_scaffold_config

      def dynamic_scaffold(model)
        self.dynamic_scaffold_config = Config.new(model)
        yield dynamic_scaffold_config if block_given?
      end
    end

    def index
      @records = self.class.dynamic_scaffold_config.model.all
      @records = @records.where scope_params
      @records = @records.order self.class.dynamic_scaffold_config.list.sorter if self.class.dynamic_scaffold_config.list.sorter
    end

    def new
      @record = self.class.dynamic_scaffold_config.model.new
      @record.attributes = scope_params
    end

    def edit
      @record = find_record(edit_params)
    end

    def sort_or_destroy
      if !params['submit_sort'].nil?
        sort
      elsif !params['submit_destroy'].nil?
        destroy
      end
    end

    def create
      @record = self.class.dynamic_scaffold_config.model.new
      @record.attributes = update_values
      if @record.save
        redirect_to path_for(:index)
      else
        render "#{params[:controller]}/new"
      end
    end

    def update
      values = update_values
      @record = find_record(extract_pkeys(values))
      @record.attributes = values
      if @record.save
        redirect_to path_for(:index)
      else
        render "#{params[:controller]}/edit"
      end
    end

    # Get the path specifying an action.
    def path_for(action, options = {})
      route = Rails.application.routes.routes.find do |r|
        route_params = r.required_defaults
        route_params[:controller] == params[:controller] && (route_params[:action] == action.to_s && r.name)
      end

      if route.nil?
        raise DynamicScaffold::Error::RouteNotFound,
          "Missing controller#action #{params[:controller]}##{action}"
      end

      public_send("#{route.name}_path", options)
    end

    private

      # Sub actions.
      def destroy
        record = find_record(JSON.parse(params['submit_destroy']))
        begin
          record.destroy
        rescue ::ActiveRecord::InvalidForeignKey => _error
          flash[:dynamic_scaffold_danger] = I18n.t('dynamic_scaffold.alert.destroy.invalid_foreign_key')
        end

        redirect_to path_for(:index)
      end

      def sort
        c = self.class.dynamic_scaffold_config
        pkeys_list = sort_params
        reset_sequence(pkeys_list.size)
        c.model.transaction do
          pkeys_list.each do |pkeys|
            rec = find_record(pkeys.to_hash)
            rec.update!(c.list.sorter_attribute => next_sequence!)
          end
        end
        redirect_to path_for(:index)
      end

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

      def sort_params
        params
          .require('pkeys')
          .map{|p| p.permit(*self.class.dynamic_scaffold_config.model.primary_key) }
      end

      def update_values
        values = params
          .require(self.class.dynamic_scaffold_config.model.name.underscore)
          .permit(*self.class.dynamic_scaffold_config.form.fields.map(&:strong_parameter))

        if self.class.dynamic_scaffold_config.scope && !valid_for_scope?(values, scope_params)
          raise DynamicScaffold::Error::InvalidParameter, "You can update only to #{scope_params} on this scope"
        end

        values
      end

      def valid_for_scope?(update_params, scope_params)
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
  end
end
