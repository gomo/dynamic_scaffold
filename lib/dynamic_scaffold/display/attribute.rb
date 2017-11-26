module DynamicScaffold
  module Display
    class Attribute
      def initialize(attribute_name, options = {})
        @label = options.delete(:label)
        @attribute_name = attribute_name
      end

      def value(record)
        record.public_send(@attribute_name)
      end

      def label(record)
        return @label if @label
        record.class.human_attribute_name(@attribute_name)
      end
    end
  end
end
