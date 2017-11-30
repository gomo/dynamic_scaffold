module DynamicScaffold
  module Form
    class RadioButtons < CollectionBase
      def render(form, classnames = nil)
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
