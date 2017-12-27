module DynamicScaffold
  module Form
    module Field
      class DatetimeSelect < Base
        def initialize(config, type, name, options = {}, html_attributes = {})
          super(config, type, name, html_attributes)
          @options = options
        end

        def render(_view, form, classnames = nil)
          form.datetime_select(@name, @options, build_html_attributes(classnames))
        end
      end
    end
  end
end
