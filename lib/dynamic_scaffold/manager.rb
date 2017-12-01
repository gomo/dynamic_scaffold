module DynamicScaffold
  class Manager
    attr_reader :model, :form, :list
    def initialize(model)
      @model = model
      @form = FormBuilder.new(self)
      @list = ListBuilder.new(self)
    end

    def records
      model.all
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
        @fields << Form::Element.new(name, *args)
      end
    end

    def initialize(manager)
      @manager = manager
      @fields = []
    end

    def fields
      if @fields.empty?
        @manager.model.column_names.each do |column|
          @fields << Form::Element.new(:text_field, column)
        end
      end
      @fields
    end

    def collection_check_boxes(*args)
      @fields << Form::CollectionCheckBoxes.new(:collection_check_boxes, *args)
    end

    def collection_radio_buttons(*args)
      @fields << Form::CollectionRadioButtons.new(:collection_radio_buttons, *args)
    end

    def collection_select(*args)
      @fields << Form::CollectionSelect.new(:collection_select, *args)
    end

    def grouped_collection_select(*args)
      @fields << Form::GroupedCollectionSelect.new(:grouped_collection_select, *args)
    end
  end
end
