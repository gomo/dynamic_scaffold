module DynamicScaffold
  module List
    module Item
      class Base
        attr_reader :classnames, :html_attributes
        def initialize(html_attributes)
          @html_attributes = html_attributes
          @classnames = @html_attributes.delete(:class)
        end
      end
    end
  end
end
