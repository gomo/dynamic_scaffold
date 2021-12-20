# frozen_string_literal: true

module DynamicScaffold
  module Form
    module Item
      class Block < Base
        def initialize(config, type, name, options = {}, &block)
          super(config, type, name, options)
          @block = block
        end

        def render(view, form, classnames = nil)
          view.instance_exec(form, self, classnames, &@block)
        end
      end
    end
  end
end
