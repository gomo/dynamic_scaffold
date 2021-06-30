module JSONObjectAttribute
  extend ActiveSupport::Concern

  module ClassMethods
    def json_object_attributte(attribute_name, model)
      unless model.respond_to? :dump
        model.define_singleton_method(:dump) do |obj|
          obj = obj.attributes if obj.is_a? ActiveModel::Attributes
          obj.to_json if obj
        end
      end

      unless model.respond_to? :load
        model.define_singleton_method(:load) do |source|
          new(source ? JSON.parse(source) : {})
        end
      end

      serialize attribute_name, model
    end
  end
end
