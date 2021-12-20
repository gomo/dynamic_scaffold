# frozen_string_literal: true

module DynamicScaffold
  module Form
    module Item
      class TwoOptionsWithBlock < TwoOptions
        def render(view, form, classnames = nil)
          form.public_send(
            @type,
            @name,
            *build_args(view, @args),
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
