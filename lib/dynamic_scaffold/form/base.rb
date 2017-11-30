module DynamicScaffold
  module Form
    class Base
      def initialize(*args)
        @html_attributes = args.extract_options!
        classnames = @html_attributes.delete(:class)
        @classnames_list = []
        @classnames_list.push(classnames) if classnames
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

      def label?
        !@label.nil?
      end

      def label(form)
        return @label if @label
        form.object.class.human_attribute_name @attribute_name if @attribute_name
      end

      protected

        def build_html_attributes(classnames)
          classnames_list = @classnames_list
          classnames_list = [*classnames_list, classnames] if classnames
          options = @html_attributes.dup
          options[:class] = classnames_list.join(' ') unless classnames_list.empty?
          options
        end
    end
  end
end
