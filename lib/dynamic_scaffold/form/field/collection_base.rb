module DynamicScaffold
  module Form
    module Field
      class CollectionBase < Base
        def initialize(manager, type, name, collection, value_method, text_method, options = {}, html_attributes = {}) # rubocop:disable Metrics/ParameterLists, Metrics/LineLength
          super(manager, type, name, html_attributes)
          @collection = collection
          @value_method = value_method
          @text_method = text_method
          @options = options
          @multiple = true if type == :collection_check_boxes || html_attributes[:multiple]
        end
      end
    end
  end
end
