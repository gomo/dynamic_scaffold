module DynamicScaffold
  module Display
    class Base
      def initialize(*args)
        @html_attrs = args.extract_options!
        @class_attr = @html_attrs.delete(:class)
        @attribute_name = args[0]
        @label = args[1]
      end

      def value(record)
        record.public_send(@attribute_name)
      end

      def label(record)
        return @label if @label
        record.class.human_attribute_name(@attribute_name)
      end

      def class_attr
        "class=\"#{@class_attr}\""
      end

      def html_attr
        @html_attrs.map {|k, v| "#{k}=\"#{v}\"" }.join(' ')
      end
    end
  end
end
