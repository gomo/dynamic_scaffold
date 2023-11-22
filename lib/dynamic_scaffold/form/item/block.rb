# frozen_string_literal: true

module DynamicScaffold
  module Form
    module Item
      class Block < Base
        def initialize(config, type, name, options = {}, &block)
          super(config, type, name, options)
          @block = block
        end

        # The `block` renders the return value of the block, so html_attributes is not relevant,
        # but it is called with `autocomplete="new-password"` because of the `if` statement in _row.html.erb.
        def render(view, form, classnames = nil, _html_attributes = {})
          view.instance_exec(form, self, classnames, &@block)
        end
      end
    end
  end
end
