module DynamicScaffold
  module Form
    class CheckBoxes
      def initialize(*args)
        @name = args[0]
        @type = args[1]
        @query = args[2]
        @value_attribute_name = args[3]
        @label_attribute_name = args[4]
        @label = args[5]
      end

      def label?
        !@label.nil?
      end

      def label(_form)
        @label
      end

      def render(form)
        form.collection_check_boxes(@name, @query, @value_attribute_name, @label_attribute_name) do |builder|
          yield builder
        end
      end

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
    end
  end
end
