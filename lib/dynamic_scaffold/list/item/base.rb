module DynamicScaffold
  module List
    module Item
      class Base
        attr_reader :classnames, :html_attributes
        def initialize(manager, html_attributes)
          @manager = manager
          @html_attributes = html_attributes
          @classnames = @html_attributes.delete(:class)
        end

        def label(label = nil)
          if label
            @label = label
            self
          elsif @label
            @label
          elsif @attribute_name
            @manager.model.human_attribute_name @attribute_name
          end
        end
      end
    end
  end
end
