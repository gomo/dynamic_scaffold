module DynamicScaffold
  module Form
    class SelectOptions < CollectionBase
      def render(form, classnames = nil)
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
