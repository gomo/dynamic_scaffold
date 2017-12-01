module DynamicScaffold
  module List
    module Item
      class Base
        attr_reader :classnames, :html_attributes
        def initialize(html_attributes)
          @html_attributes = html_attributes
          @classnames = @html_attributes.delete(:class)
        end

        def label(arg)
          if arg.is_a? String
            @label = arg
            self
          else
            return @label if @label
            # TODO Stop passing form to label. (Make FormField and List::Item have manager reference)
            arg.class.human_attribute_name @attribute_name
          end
        end
      end
    end
  end
end
