module DynamicScaffold
  module List
    module Item
      class Attribute < Base
        def initialize(*args)
          super(args[0], args.extract_options!)
          @attribute_name = args[1]
        end

        def value(record, _view)
          record.public_send(@attribute_name)
        end
      end
    end
  end
end
