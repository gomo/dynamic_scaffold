module DynamicScaffold
  module Form
    module Item
      class SingleOption < Base
        def initialize(config, type, *args)
          name = args.shift
          html_attributes = args.extract_options!
          @args = args
          super(config, type, name, html_attributes)
        end

        def render(view, form, classnames = nil)
          html_attributes = build_html_attributes(classnames)
          # Retain the value of the password field on error.
          html_attributes[:value] = form.object.public_send(@name) if @type == :password_field
          form.public_send(@type, @name, *build_args(view, @args), html_attributes)
        end
      end
    end
  end
end
