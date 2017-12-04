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

    def sort
      params = sort_params
      @dynamic_scaffold_util.reset_sequence params.size
      @dynamic_scaffold.model.transaction do
        params.each do |pkeys|
          rec = @dynamic_scaffold.model.where(pkeys).first
          rec.update!(
            @dynamic_scaffold.list.sorter_attribute => @dynamic_scaffold_util.next_sequence!
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
