module DynamicScaffold
  module Form
    class Element < Base
      def initialize(*args)
        super(*args)

        @attribute_name = args[0]
        @type = args[1]
        @label = args[2]
      end

      def render(form, classnames = nil)
        form.public_send(@type, @attribute_name, build_html_attributes(classnames))
      end
    end
  end
end
