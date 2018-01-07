module DynamicScaffold
  module Form
    module Field
      class Single < Base
        def initialize(config, type, name, html_attributes = {})
          super(config, type, name, html_attributes)
        end

        def render(_view, form, classnames = nil)
          html_attributes = build_html_attributes(classnames)
          # Retain the value of the password field on error.
          html_attributes[:value] = form.object.public_send(@name) if @type == :password_field
          form.public_send(@type, @name, html_attributes)
        end
      end
    end
  end
end
