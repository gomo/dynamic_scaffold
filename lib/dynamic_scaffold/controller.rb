module DynamicScaffold
  module Controller
    extend ActiveSupport::Concern

    class_methods do
      attr_accessor :manager

      def dynamic_scaffold(model)
        self.manager = Manager.new(model)
        yield manager
      end
    end

    included do
      before_action do
        @manager = self.class.manager
      end
    end

    def index
    end

    def new
      @record = @manager.model.new
    end
  end
end
