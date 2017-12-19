module DynamicScaffold
  module Form
    module Field
      class Block < Base
        def initialize(config, type, name, block)
          super(config, type, name, {})
          @block = block
        end

        def render(form, _classnames = nil)
          @block.call(form, self)
        end
      end
    end
  end
end
