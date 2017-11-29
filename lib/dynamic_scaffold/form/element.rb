module DynamicScaffold
  module Form
    class Element < Base
      def initialize(*args)
        @html_attributes = args.extract_options!
        classnames = @html_attributes.delete(:class)
        @classnames_list = []
        @classnames_list.push(classnames) if classnames

        @attribute_name = args[0]
        @type = args[1]
        @label = args[2]
      end

      def label(form)
        return @label if @label
        form.object.class.human_attribute_name @attribute_name
      end

      def render(form, classnames = nil)
        classnames_list = @classnames_list
        classnames_list = [*classnames_list, classnames] if classnames

        options = @html_attributes.dup
        options[:class] = classnames_list.join(' ') unless classnames_list.empty?

        form.public_send(@type, @attribute_name, options)
      end
    end
  end
end
