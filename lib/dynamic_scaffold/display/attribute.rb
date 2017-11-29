module DynamicScaffold
  module Display
    class Attribute
      attr_reader :classnames, :html_attributes
      def initialize(*args)
        @html_attributes = args.extract_options!
        @classnames = @html_attributes.delete(:class)
        @attribute_name = args[0]
        if args[1].is_a? Array
          @args = args[1]
          @label = args[2]
        else
          @args = []
          @label = args[1]
        end
      end

      def value(record, _view)
        record.public_send(@attribute_name, *@args)
      end

      def label(record)
        return @label if @label
        record.class.human_attribute_name(@attribute_name)
      end
    end
  end
end
