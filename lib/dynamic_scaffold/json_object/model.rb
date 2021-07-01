module DynamicScaffold
  module JSONObject
    module Model
      extend ActiveSupport::Concern

      module ClassMethods
        def  dump(obj)
          obj = obj.attributes if obj.is_a? ActiveModel::Attributes
          obj.to_json if obj
        end

        def load(source)
          new(source ? JSON.parse(source) : {})
        end
      end
    end
  end
end
