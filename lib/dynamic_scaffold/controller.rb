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
        @scaffold = self.class.manager
      end
    end

    def index
    end
  end
end
