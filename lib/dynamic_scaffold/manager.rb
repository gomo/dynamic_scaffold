module DynamicScaffold
  class Manager
    attr_accessor :model
    attr_reader :form
    def initialize(model)
      self.model = model
      @dispalys = []
      @forms = []
      @form = FormBuilder.new(self)
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
          @forms << Form::Element.new(:text_field, column)
        end
      end
      @forms
    end

    def _add_form(form)
      @forms << form
    end

    # def add_form(*args)
    #   case args[1]
    #   when :collection_check_boxes then
    #     elem = Form::CollectionCheckBoxes.new(*args)
    #   when :collection_radio_buttons then
    #     elem = Form::CollectionRadioButtons.new(*args)
    #   when :collection_select then
    #     elem = Form::CollectionSelect.new(*args)
    #   when :grouped_collection_select then
    #     elem = Form::GroupedCollectionSelect.new(*args)
    #   else
    #     elem = Form::Element.new(*args)
    #   end
    #   @forms << elem
    #   elem
    # end
  end

  class FormBuilder
    %i[
      text_field
      check_box
      radio_button
      password_field
      hidden_field
      file_field
      text_area
      color_field
    ].each do |name|
      define_method(name) do |*args|
        @manager._add_form(Form::Element.new(name, *args))
      end
    end

    def initialize(manager)
      @manager = manager
    end

    def collection_check_boxes(*args)
      @manager._add_form(
        Form::CollectionCheckBoxes.new(:collection_check_boxes, *args)
      )
    end

    def collection_radio_buttons(*args)
      @manager._add_form(
        Form::CollectionRadioButtons.new(:collection_radio_buttons, *args)
      )
    end

    def collection_select(*args)
      @manager._add_form(
        Form::CollectionSelect.new(:collection_select, *args)
      )
    end

    def grouped_collection_select(*args)
      @manager._add_form(
        Form::GroupedCollectionSelect.new(:grouped_collection_select, *args)
      )
    end
  end
end
