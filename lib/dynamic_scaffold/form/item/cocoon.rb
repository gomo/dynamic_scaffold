module DynamicScaffold
  module Form
    module Item
      class Cocoon < Base
        attr_reader :form
        def initialize(config, type, name, options = {})
          super
          @form = FormBuilder.new(config)
          yield(@form)
        end

        def extract_parameters(permitting)
          permitting << {"#{@name}_attributes": [*@form.items.map(&:name).push(:_destroy)]}
        end
      end
    end
  end
end
