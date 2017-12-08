module DynamicScaffold
  module ActiveRecord
    extend ActiveSupport::Concern

    included do
      include DynamicScaffold::ActiveRecord::LocalInstanceMethods
    end

    module LocalInstanceMethods
      def primary_key_value
        [*self.class.primary_key].each_with_object({}) {|col, res| res[col] = self[col] }
      end
    end
  end
end

::ActiveRecord::Base.send :include, DynamicScaffold::ActiveRecord
