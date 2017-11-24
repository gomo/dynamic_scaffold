require 'active_support/core_ext/class/attribute'
module DynamicScaffold
  module Controller
    extend ActiveSupport::Concern

    class_methods do
      attr_accessor :manager

      def dynamic_scaffold(model)
        self.manager = Manager.new(model)
        yield self.manager
      end
    end

    def index
      @test_var = 'foobar'
      render 'dynamic_scaffold/index'
    end
  end
end
