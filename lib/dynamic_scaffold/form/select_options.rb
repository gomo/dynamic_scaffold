module DynamicScaffold
  module Form
    class SelectOptions < Base
      def initialize(name, type, collection, value_method, text_method, label = nil, options = {}, html_attributes = {})
        detect_html_attributes!([html_attributes])
        @name = name
        @type = type
        @collection = collection
        @value_method = value_method
        @text_method = text_method
        @options = options
        @label = label
      end

      def label(_form)
        @label
      end

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
