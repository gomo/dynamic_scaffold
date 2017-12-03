module DynamicScaffold
  module Controller
    extend ActiveSupport::Concern

    class_methods do
      attr_accessor :manager

      def dynamic_scaffold(model)
        self.manager = Manager.new(model)
        yield manager if block_given?
      end
    end

    included do
      before_action do
        @manager = self.class.manager
      end
    end

    def index; end

    def new
      @record = @manager.model.new
    end

    def sort
      params = sort_params
      @manager.list.init_sequence params
      @manager.model.transaction do
        params.each do |pkeys|
          rec = @manager.model.where(pkeys).first
          rec.update!(
            @manager.list.sorter_attribute => @manager.list.next_sequence!
          )
        end
      end

      redirect_back fallback_location: '/', status: 303
    end

    private

      def sort_params
        # Support multiple pkey
        # Convert ["key:1,code:foo"] to [{key: "1", code: "foo"}]
        params['pkeys'].map do |chunk|
          chunk.split(',').map {|v| v.split(':') }.each_with_object({}) {|v, res| res[v.first] = v.last }
        end
      end
  end
end
