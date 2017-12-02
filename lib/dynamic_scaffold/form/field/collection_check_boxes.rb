module DynamicScaffold
  module Form
    module Field
      class CollectionCheckBoxes < CollectionBase
        def render(form, classnames = nil)
          form.collection_check_boxes(
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
