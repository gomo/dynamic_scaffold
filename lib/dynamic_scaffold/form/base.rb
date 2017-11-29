module DynamicScaffold
  module Form
    class Base
      def description(&block)
        @description = block if block_given?
        @description
      end

      def description?
        @description != nil
      end

      def type?(type)
        @type == type
      end

      def label?
        !@label.nil?
      end
    end
  end
end
