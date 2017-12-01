module DynamicScaffold
  module List
    module Item
      class Attribute < Base
        def initialize(*args)
          super(args.extract_options!)
          @attribute_name = args[0]
        end

        def value(record, _view)
          record.public_send(@attribute_name)
        end
      end
    end
  end
end
