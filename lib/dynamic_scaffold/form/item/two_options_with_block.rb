module DynamicScaffold
  module Form
    module Item
      class TwoOptionsWithBlock < TwoOptions
        def render(_view, form, classnames = nil)
          form.public_send(
            @type,
            @name,
            *@args,
            @options,
            build_html_attributes(classnames)
          ) do |builder|
            yield builder
          end
        end
      end
    end
  end
end