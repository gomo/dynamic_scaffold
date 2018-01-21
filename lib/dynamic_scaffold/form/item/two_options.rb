module DynamicScaffold
  module Form
    module Item
      class TwoOptions < Base
        def initialize(config, type, *args)
          name = args.shift
          if args[args.length - 2].is_a?(Hash)
            html_attributes = args.extract_options!
            @options = args.extract_options!
          else
            html_attributes = {}
            @options = args.extract_options!
          end

          @args = args
          super(config, type, name, html_attributes)
        end

        def render(_view, form, classnames = nil)
          html_attributes = build_html_attributes(classnames)
          form.public_send(@type, @name, *@args, @options, html_attributes)
        end
      end
    end
  end
end
