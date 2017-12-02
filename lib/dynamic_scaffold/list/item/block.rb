module DynamicScaffold
  module List
    module Item
      class Block < Base
        def initialize(*args, block)
          super(args[0], args.extract_options!)
          @label = args[1]
          @block = block
        end

        def value(record, view)
          view.instance_exec(record, &@block)
        end
      end
    end
  end
end
