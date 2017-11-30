module DynamicScaffold
  module Form
    class CheckablesBase < Base
      def initialize(*args)
        @name = args[0]
        @type = args[1]
        @query = args[2]
        @value_method = args[3]
        @text_method = args[4]
        @label = args[5]
      end

      def label(_form)
        @label
      end
    end
  end
end
