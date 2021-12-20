# frozen_string_literal: true

module DynamicScaffold
  module Form
    module Item
      class JSONObject < Base
        attr_reader :form
        def initialize(config, type, name, options = {})
          super
          @options = options
          @form = FormBuilder.new(config)
          @form.parent_item = self
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
