module DynamicScaffold
  module Form
    module Item
      class JSON < Base
        attr_reader :form
        def initialize(config, type, name, options = {})
          super
          @options = options
          @form = FormBuilder.new(config)
          yield(@form)
        end

        # the lable is always empty.
        def render_label(view, depth)
          ''
        end

        def extract_parameters(permitting)
          hash = {}
          hash[name] = form.items.map(&:name)
          permitting << hash
        end

        def build_child(record)
          child = @options[:model].new
          json_data = record.public_send(name)
          return child if json_data.nil?

          json_data.each do |key, value|
            child.public_send("#{key}=", value)
          end

          child
        end
      end
    end
  end
end
