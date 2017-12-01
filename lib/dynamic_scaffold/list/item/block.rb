module DynamicScaffold
  module List
    module Item
      class Block < Base
        def initialize(*args, block)
          super(args.extract_options!)
          @label = args[0]
          @block = block
        end
  
        def value(record, view)
          view.instance_exec(record, &@block)
        end
  
        def label(_record)
          @label
        end
      end
    end
  end
end
