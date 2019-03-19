module DynamicScaffold
  module List
    class Item
      attr_reader :classnames, :html_attributes

      def initialize(config, *args, block)
        @config = config
        @html_attributes = args.extract_options!
        @classnames = @html_attributes.delete(:class)
        @attribute_name = args[0]
        @block = block
      end

      def value(view, record)
        if @block
          view.instance_exec(record, @attribute_name, &@block)
        else
          record.public_send(@attribute_name)
        end
      end

      def label(label = nil)
        if label
          @label = label
          self
        elsif @label
          @label
        elsif @attribute_name
          @config.model.human_attribute_name @attribute_name
        end
      end
    end
  end
end
