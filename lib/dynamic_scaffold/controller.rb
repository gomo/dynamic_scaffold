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
      target_params = key_params.merge(scope_params)
      @record = self.class.dynamic_scaffold_config.model.find_by(target_params)
      raise ActiveRecord::RecordNotFound if @record.nil?
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
      @record.attributes = record_params
      if @record.save
        redirect_to path_for(:index)
      else
        render "#{params[:controller]}/new"
      end
    end

    def update
      update_params = record_params
      target_params = extract_pkeys(update_params).merge(scope_params)
      @record = self.class.dynamic_scaffold_config.model.find_by(target_params)
      raise ActiveRecord::RecordNotFound if @record.nil?
      if self.class.dynamic_scaffold_config.scope && !valid_for_scope?(update_params, scope_params)
        raise DynamicScaffold::Error::InvalidParameter, "You can update only to #{scope_params} on this scope"
      end

      @record.attributes = update_params
      if @record.save
        redirect_to path_for(:index)
      else
        render "#{params[:controller]}/edit"
      end
    end

    # This method is public as it is called from view.
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

    # This method is public as it is called from view.
    def pkey_params(record)
      [*record.class.primary_key].each_with_object({}) {|col, res| res[col] = record[col] }
    end

    # This method is public as it is called from view.
    def pkey_string(record)
      pkey_params(record).map {|k, v| "#{k}:#{v}" }.join(',')
    end
    private

      def scope_params
        return {} if self.class.dynamic_scaffold_config.scope.nil?
        self.class.dynamic_scaffold_config.scope.each_with_object({}) {|attr, res| res[attr] = params[attr] }
      end

      def extract_pkeys(values)
        [*self.class.dynamic_scaffold_config.model.primary_key].each_with_object({}) {|col, res| res[col] = values[col] }
      end

      def destroy
        pkey_params = pkey_to_hash(params['submit_destroy']).merge(scope_params)
        record = self.class.dynamic_scaffold_config.model.find_by(pkey_params)
        raise ActiveRecord::RecordNotFound if record.nil?
        begin
          record.destroy
        rescue ActiveRecord::InvalidForeignKey => _error
          flash[:dynamic_scaffold_danger] = I18n.t('dynamic_scaffold.alert.destroy.invalid_foreign_key')
        end

        redirect_to path_for(:index)
      end

      def sort
        reset_sequence(params['pkeys'].size)
        self.class.dynamic_scaffold_config.model.transaction do
          params['pkeys'].each do |pkeys|
            pkey_params = pkey_to_hash(pkeys).merge(scope_params)
            rec = self.class.dynamic_scaffold_config.model.find_by(pkey_params)
            raise ActiveRecord::RecordNotFound if rec.nil?
            rec.update!(
              self.class.dynamic_scaffold_config.list.sorter_attribute => next_sequence!
            )
          end
        end

        redirect_back fallback_location: path_for(:index), status: 303
      end

      def pkey_to_hash(pkey)
        # Support multiple pkey
        # Convert "key:1,code:foo" to {key: "1", code: "foo"}
        pkey.split(',').map {|v| v.split(':') }.each_with_object({}) {|v, res| res[v.first] = v.last }
      end

      def key_params
        params
          .require('key')
          .permit(*self.class.dynamic_scaffold_config.model.primary_key)
      end

      def record_params
        params
          .require(self.class.dynamic_scaffold_config.model.name.underscore)
          .permit(*self.class.dynamic_scaffold_config.form.fields.map(&:strong_parameter))
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
  end
end
