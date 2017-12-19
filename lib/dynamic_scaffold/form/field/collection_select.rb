module DynamicScaffold
  module Form
    module Field
      class CollectionSelect < CollectionBase
        def render(view, form, classnames = nil)
          form.collection_select(
            @name,
            @collection,
            @value_method,
            @text_method,
            @options,
            build_html_attributes(classnames)
          )
        end
      end
    end
  end
end
