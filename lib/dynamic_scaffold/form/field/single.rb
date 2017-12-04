module DynamicScaffold
  module Form
    module Field
      class Single < Base
        def initialize(config, type, name, html_attributes = {})
          super(config, type, name, html_attributes)
        end

        def render(form, classnames = nil)
          form.public_send(@type, @name, build_html_attributes(classnames))
        end
      end
    end
  end
end
