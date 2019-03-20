module DynamicScaffold
  module Form
    module Item
      class Cocoon < Base
        attr_reader :form
        def initialize(config, type, name, options = {})
          super
          @options = options
          @form = FormBuilder.new(config)
          yield(@form)
        end

        def extract_parameters(permitting)
          permitting << { "#{@name}_attributes": [*@form.items.map(&:name).push(:_destroy)] }
        end

        def filter(&block)
          @filter = block
          self
        end

        def add_text
          @options[:add_text] || "Add #{proxy_field.label}"
        end

        def build_children(record)
          children = record.public_send(name).to_a
          children = @filter.call(children) if @filter.present?
          children
        end
      end
    end
  end
end
