module DynamicScaffold
  module Form
    module Field
      class CollectionBase < Base
        def initialize(manager, name, type, collection, value_method, text_method, options = {}, html_attributes = {}) # rubocop:disable Metrics/ParameterLists, Metrics/LineLength
          super(manager, name, type, html_attributes)
          @collection = collection
          @value_method = value_method
          @text_method = text_method
          @options = options
        end
      end
    end
  end
end
