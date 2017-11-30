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

    def add_display(*args, &block)
      if block_given?
        @dispalys << Display::Block.new(*args, block)
      else
        @dispalys << Display::Attribute.new(*args)
      end
    end

    def forms
      if @forms.empty?
        model.column_names.each do |column|
          @forms << Form::Element.new(column, :text_field)
        end
      end
      @forms
    end

    def add_form(*args)
      case args[1]
      when :check_boxes then
        elem = Form::CheckBoxes.new(*args)
      when :radio_buttons then
        elem = Form::RadioButtons.new(*args)
      else
        elem = Form::Element.new(*args)
      end
      @forms << elem
      elem
    end
  end
end
