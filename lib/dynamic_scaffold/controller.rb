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
      begin_transaction do
        self.class.dynamic_scaffold_config.call_before_save(
          :create,
          self,
          @record
        )
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
      @record.attributes = values
      begin_transaction do
        self.class.dynamic_scaffold_config.call_before_save(
          :update,
          self,
          @record
        )
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
          record.destroy
        rescue ::ActiveRecord::InvalidForeignKey => _error
          flash[:dynamic_scaffold_danger] = I18n.t('dynamic_scaffold.alert.destroy.invalid_foreign_key')
        end

        redirect_to dynamic_scaffold_path(:index)
      end

      def sort
        pkeys_list = sort_params
        reset_sequence(pkeys_list.size)
        begin_transaction do
          pkeys_list.each do |pkeys|
            rec = find_record(pkeys.to_hash)
            next_sec = next_sequence!
            rec.attributes = { self.class.dynamic_scaffold_config.list.sorter_attribute => next_sec }
            self.class.dynamic_scaffold_config.call_before_save(
              :sort,
              self,
              rec,
              next_sec
            )
            rec.save
          end
        end
        redirect_to dynamic_scaffold_path(:index)
      end
  end
end
