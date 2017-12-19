module DynamicScaffold
  module Form
    module Field
      class CollectionRadioButtons < CollectionBase
        def render(_view, form, classnames = nil)
          form.collection_radio_buttons(
            @name,
            @collection,
            @value_method,
            @text_method,
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
