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
            model.human_attribute_name(column)
          )
        end
      end
      @dispalys
    end

    def add_display(*args, &block)
      if block
        @dispalys << Display::Block.new(*args, block)
      else
        @dispalys << Display::Attribute.new(*args)
      end
    end
  end
end
