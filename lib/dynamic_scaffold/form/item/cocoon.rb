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
      end
    end
  end
end
