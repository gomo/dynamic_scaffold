module DynamicScaffold
  module Controller
    extend ActiveSupport::Concern
    include ControllerUtilities

    included do
      helper_method :dynamic_scaffold_path, :dynamic_scaffold_icon, :dynamic_scaffold, :primary_key_value
      attr_reader :dynamic_scaffold
      before_action lambda {
        @dynamic_scaffold = Config.new(self.class.dynamic_scaffold_model, self)
        self.class.dynamic_scaffold_initializer.call(@dynamic_scaffold)
      }
    end

    class_methods do
      attr_accessor :dynamic_scaffold_model, :dynamic_scaffold_initializer

      def dynamic_scaffold(model, &block)
        self.dynamic_scaffold_model = model
        self.dynamic_scaffold_initializer = block
      end
    end

    # Actions

    def index # rubocop:disable Metrics/AbcSize
      @records = dynamic_scaffold.model.all
      raise Error::Controller, 'You must return ActiveRecord::Relation' unless @records.is_a? ::ActiveRecord::Relation

      if dynamic_scaffold.list.pagination
        @records = @records
                     .page(params[dynamic_scaffold.list.pagination.param_name])
                     .per(dynamic_scaffold.list.pagination.per_page)
      end

      @records = @records.where scope_params
      @records = @records.order dynamic_scaffold.list.sorter if dynamic_scaffold.list.sorter
      @records = @records.order(*dynamic_scaffold.list.order) unless dynamic_scaffold.list.order.empty?

      @records = yield(@records) if block_given?
      raise Error::Controller, 'You must return ActiveRecord::Relation' if @records.nil?
      @records
    end

    def new
      @record = dynamic_scaffold.model.new

      defaults = dynamic_scaffold.form.items.each_with_object({}) do |item, memo|
        memo[item.name] = item.default if dynamic_scaffold.model.column_names.include?(item.name.to_s)
      end

      @record.attributes = defaults.merge(scope_params)
    end

    def edit
      @record = find_record(edit_params)
    end

    def create
      @record = dynamic_scaffold.model.new
      prev_attribute = @record.attributes
      @record.attributes = update_values
      bind_sorter_value(@record) if dynamic_scaffold.list.sorter
      dynamic_scaffold.model.transaction do
        yield(@record, prev_attribute) if block_given?
        if @record.save
          redirect_to dynamic_scaffold_path(:index)
        else
          render "#{params[:controller]}/new"
        end
      end
    end

    def update
      values = update_values
      @record = find_record(extract_pkeys(values))
      prev_attribute = @record.attributes
      @record.attributes = values
      dynamic_scaffold.model.transaction do
        yield(@record, prev_attribute) if block_given?
        if @record.save
          redirect_to dynamic_scaffold_path(:index)
        else
          render "#{params[:controller]}/edit"
        end
      end
    end

    def destroy
      # `Destroy` also does not support multiple primary keys too.
      record = find_record(dynamic_scaffold.model.primary_key => params['id'])
      begin
        dynamic_scaffold.model.transaction do
          record.destroy
        end
      rescue ::ActiveRecord::InvalidForeignKey => _error
        flash[:dynamic_scaffold_danger] = I18n.t('dynamic_scaffold.alert.destroy.invalid_foreign_key')
      end
      redirect_to dynamic_scaffold_path(:index)
    end

    def sort
      pkeys_list = sort_params
      reset_sequence(pkeys_list.size)
      dynamic_scaffold.model.transaction do
        pkeys_list.each do |pkeys|
          rec = find_record(pkeys.to_hash)
          next_sec = next_sequence!
          rec[dynamic_scaffold.list.sorter_attribute] = next_sec
          rec.save
        end
      end
      redirect_to dynamic_scaffold_path(:index)
    end
  end
end
