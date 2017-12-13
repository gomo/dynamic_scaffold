module DynamicScaffold
  module Controller
    extend ActiveSupport::Concern
    include ControllerUtilities

    class_methods do
      attr_accessor :dynamic_scaffold_config

      def dynamic_scaffold(model)
        self.dynamic_scaffold_config = Config.new(model)
        yield dynamic_scaffold_config if block_given?
      end
    end

    # Actions

    def index # rubocop:disable Metrics/AbcSize
      @records = dsconf.model.all
      if dsconf.list.callback.exists?(:before_fetch)
        @records = dsconf.list.callback.call(:before_fetch, self, @records)
        unless @records.is_a? ::ActiveRecord::Relation
          raise Error::InvalidParameter, 'You must return ActiveRecord::Relation'
        end
      end
      @records = @records.page(params[:page]).per(dsconf.list.pagenation.per_page) if dsconf.list.pagenation?
      @records = @records.where scope_params
      @records = @records.order dsconf.list.sorter if dsconf.list.sorter
    end

    def new
      @record = dsconf.model.new
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
      @record = dsconf.model.new
      prev_attribute = @record.attributes
      @record.attributes = update_values
      dsconf.model.transaction do
        dsconf.form.callback.call(:before_save_create, self, @record, prev_attribute)
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
      dsconf.model.transaction do
        dsconf.form.callback.call(:before_save_update, self, @record, prev_attribute)
        if @record.save
          redirect_to dynamic_scaffold_path(:index)
        else
          render "#{params[:controller]}/edit"
        end
      end
    end

    private

      # Sub actions.
      def destroy
        record = find_record(JSON.parse(params['submit_destroy']))

        begin
          dsconf.model.transaction do
            dsconf.form.callback.call(:before_save_destroy, self, record, {})
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
        dsconf.model.transaction do
          pkeys_list.each do |pkeys|
            rec = find_record(pkeys.to_hash)
            next_sec = next_sequence!
            prev_attribute = rec.attributes
            rec[dsconf.list.sorter_attribute] = next_sec
            dsconf.list.callback.call(:before_save_sort, self, rec, prev_attribute)
            rec.save
          end
        end
        redirect_to dynamic_scaffold_path(:index)
      end
  end
end
