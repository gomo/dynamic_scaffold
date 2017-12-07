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

    included do
      before_action do
        @dynamic_scaffold = self.class.dynamic_scaffold_config
        @dynamic_scaffold_util = Util.new(@dynamic_scaffold, self)
      end
    end

    def index; end

    def new
      @record = @dynamic_scaffold.model.new
    end

    def edit
      @record = @dynamic_scaffold.model.find_by(key_params)
    end

    def sort_or_destroy
      if !params['submit_sort'].nil?
        sort
      elsif !params['submit_destroy'].nil?
        destroy
      end
    end

    def create
      @record = @dynamic_scaffold.model.new
      @record.attributes = record_params
      if @record.save
        redirect_to @dynamic_scaffold_util.path_for(:index)
      else
        render "#{params[:controller]}/new"
      end
    end

    def update
      rec_params = record_params
      ar = @dynamic_scaffold.model.all
      [*@dynamic_scaffold.model.primary_key].each do |pkey|
        ar = ar.where(pkey => rec_params[pkey])
      end
      @record = ar.first
      raise ActiveRecord::RecordNotFound if @record.nil?

      @record.attributes = rec_params
      if @record.save
        redirect_to @dynamic_scaffold_util.path_for(:index)
      else
        render "#{params[:controller]}/edit"
      end
    end

    private

      def destroy
        pkey_params = pkey_to_hash(params['submit_destroy'])
        record = @dynamic_scaffold.model.find_by(pkey_params)
        raise ActiveRecord::RecordNotFound if record.nil?
        begin
          record.destroy
        rescue ActiveRecord::InvalidForeignKey => _error
          flash[:dynamic_saffold_danger] = I18n.t('dynamic_scaffold.alert.destroy.invalid_foreign_key')
        end

        redirect_to @dynamic_scaffold_util.path_for(:index)
      end

      def sort
        @dynamic_scaffold_util.reset_sequence params['pkeys'].size
        @dynamic_scaffold.model.transaction do
          params['pkeys'].each do |pkeys|
            pkey_params = pkey_to_hash(pkeys)
            rec = @dynamic_scaffold.model.find_by(pkey_params)
            rec.update!(
              @dynamic_scaffold.list.sorter_attribute => @dynamic_scaffold_util.next_sequence!
            )
          end
        end

        redirect_back fallback_location: @dynamic_scaffold_util.path_for(:index), status: 303
      end

      def pkey_to_hash(pkey)
        # Support multiple pkey
        # Convert "key:1,code:foo" to {key: "1", code: "foo"}
        pkey.split(',').map {|v| v.split(':') }.each_with_object({}) {|v, res| res[v.first] = v.last }
      end

      def key_params
        params
          .require('key')
          .permit(*@dynamic_scaffold.model.primary_key)
      end

      def record_params
        params
          .require(@dynamic_scaffold.model.name.underscore)
          .permit(*@dynamic_scaffold.form.fields.map(&:strong_parameter))
      end
  end
end
