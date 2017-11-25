module DynamicScaffold
  module Display
    class Attribute
      attr_accessor :label
      def initialize(label, attribute_name)
        self.label = label
        @attribute_name = attribute_name
      end

      def value(record)
        record[@attribute_name]
      end
    end
  end
end
