module DynamicScaffold
  class Manager
    attr_accessor :model
    def initialize(model)
      self.model = model
      @dispalys = []
    end

    def list
      model.all
    end

    def displays
      if @dispalys.empty?
        model.column_names.each do |column|
          @dispalys << Display::Attribute.new(
            column,
            label: model.human_attribute_name(column)
          )
        end
      end
      @dispalys
    end
  end
end
