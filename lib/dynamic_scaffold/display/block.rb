module DynamicScaffold
  module Display
    class Block
      attr_reader :classnames, :html_attributes
      def initialize(*args, block)
        @html_attributes = args.extract_options!
        @classnames = @html_attributes.delete(:class)
        @attribute_name = args[0]
        @label = args[0]
        @block = block
      end

      def value(record, view)
        view.instance_exec(record, &@block)
      end

      def label(_record)
        @label
      end
    end
  end
end
