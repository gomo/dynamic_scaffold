module DynamicScaffold
  class Manager
    attr_reader :model, :form, :list
    def initialize(model)
      @model = model
      @forms = []
      @form = FormBuilder.new(self)
      @list = ListBuilder.new(self)
    end

    def records
      model.all
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
  end

  class ListBuilder
    def initialize(manager)
      @manager = manager
      @items = []
    end

    def item(*args, &block)
      if block
        @items << Display::Block.new(*args, block)
      else
        @items << Display::Attribute.new(*args)
      end
    end

    def items
      if @items.empty?
        @manager.model.column_names.each do |column|
          @items << Display::Attribute.new(column)
        end
      end
      @items
    end
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
