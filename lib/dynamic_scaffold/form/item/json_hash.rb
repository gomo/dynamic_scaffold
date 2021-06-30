module DynamicScaffold
  module Form
    module Item
      class JSONHash < Base
        attr_reader :form
        def initialize(config, type, name, options = {})
          super
          @options = options
          @form = FormBuilder.new(config)
          yield(@form)
        end

        # the lable is always empty.
        def render_label(_view, _depth)
          ''
        end

        def extract_parameters(permitting)
          hash = permitting.find {|e| e.is_a?(Hash) && e.key?(name) }
          if hash.nil?
            hash = {}
            hash[name] = form.items.map(&:name)
            permitting << hash
          else
            hash[name].concat(form.items.map(&:name))
          end
        end
      end
    end
  end
end
