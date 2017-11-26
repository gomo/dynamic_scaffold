module DynamicScaffold
  module Display
    class Block
      def initialize(*args, block)
        @html_attrs = args.extract_options!
        @class_attr = @html_attrs.delete(:class)
        @label = args[0]
        @block = block
      end

      def value(record)
        @block.call record
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
