module DynamicScaffold
  module Display
    class Attribute
      def initialize(*args)
        @html_attrs = args.extract_options!
        @class_attr = @html_attrs.delete(:class)
        @attribute_name = args[0]
        if args[1].is_a? Array
          @args = args[1]
          @label = args[2]
        else
          @args = []
          @label = args[1]
        end
        
      end

      def value(record)
        record.public_send(@attribute_name, *@args)
      end

      def label(record)
        return @label if @label
        record.class.human_attribute_name(@attribute_name)
      end

      def class_attr_value
        @class_attr
      end

      def html_attr
        @html_attrs.map {|k, v| "#{k}=\"#{v}\"" }.join(' ').html_safe
      end
    end
  end
end
