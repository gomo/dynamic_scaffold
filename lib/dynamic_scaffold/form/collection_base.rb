module DynamicScaffold
  module Form
    class CollectionBase < Base
      def initialize(name, type, collection, value_method, text_method, label = nil, options = {}, html_attributes = {}) # rubocop:disable Metrics/ParameterLists, Metrics/LineLength
        super(name, type, label, html_attributes)
        @collection = collection
        @value_method = value_method
        @text_method = text_method
        @options = options
      end
    end
  end
end
