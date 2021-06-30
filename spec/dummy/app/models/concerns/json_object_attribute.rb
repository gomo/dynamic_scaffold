module JSONObjectAttribute
  extend ActiveSupport::Concern

  included do
    @json_object_attribute_names ||= []

    define_method :valid? do |context = nil|
      result = super(context)
      json_object_attribute_names = self.class.instance_variable_get(:@json_object_attribute_names)
      json_object_attribute_names.all? {|method| public_send(method).valid?(context) } && result
    end
  end

  module ClassMethods
    def json_object_attributte(attribute_name, model)
      @json_object_attribute_names << attribute_name
      serialize attribute_name, model
    end
  end
end
