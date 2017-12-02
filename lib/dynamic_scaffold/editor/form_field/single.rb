module DynamicScaffold
  module Editor
    module FormField
      class Single < Base
        def initialize(*args)
          html_attributes = args.extract_options!
          super(args[0], args[1], args[2], html_attributes)
        end

        def render(form, classnames = nil)
          form.public_send(@type, @name, build_html_attributes(classnames))
        end
      end
    end
  end
end
