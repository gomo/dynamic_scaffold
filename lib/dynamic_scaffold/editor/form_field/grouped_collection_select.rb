module DynamicScaffold
  module Editor
    module FormField
      class GroupedCollectionSelect < CollectionBase
        def initialize(name, type, collection, group_method, group_label_method, option_key_method, option_value_method, options = {}, html_options = {}) # rubocop:disable Metrics/ParameterLists, Metrics/LineLength
          super(name, type, collection, option_key_method, option_value_method, options, html_options)
          @group_method = group_method
          @group_label_method = group_label_method
        end

        def render(form, classnames = nil)
          form.grouped_collection_select(
            @name,
            @collection,
            @group_method,
            @group_label_method,
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
