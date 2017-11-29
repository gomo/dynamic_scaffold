module DynamicScaffold
  class Manager
    attr_accessor :model
    def initialize(model)
      self.model = model
      @dispalys = []
      @forms = []
    end

    def list
      model.all
    end

    def displays
      if @dispalys.empty?
        model.column_names.each do |column|
          @dispalys << Display::Attribute.new(column)
        end
      end
      @dispalys
    end

    def add_display(*args)
      @dispalys << Display::Attribute.new(*args)
    end

    def forms
      if @forms.empty?
        model.column_names.each do |column|
          @forms << FormElement.new(column, :text_field)
        end
      end
      @forms
    end

    def add_form(*args)
      elem = FormElement.new(*args)
      @forms << elem
      elem
    end
  end
end
