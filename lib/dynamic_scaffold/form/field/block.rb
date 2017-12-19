module DynamicScaffold
  module Form
    module Field
      class Block < Base
        def initialize(config, type, name, block)
          super(config, type, name, {})
          @block = block
        end

        def render(view, form, classnames = nil)
          view.instance_exec(form, self, classnames, &@block)
        end
      end
    end
  end
end
