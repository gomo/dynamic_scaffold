module DynamicScaffold
  class Manager
    attr_reader :model, :editor, :list
    def initialize(model)
      @model = model
      @editor = EditorBuilder.new(self)
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

  class EditorBuilder
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
        @form_fields << Form::Element.new(name, *args)
      end
    end

    def initialize(manager)
      @manager = manager
      @form_fields = []
    end

    def form_fields
      if @form_fields.empty?
        @manager.model.column_names.each do |column|
          @form_fields << Form::Element.new(:text_field, column)
        end
      end
      @form_fields
    end

    def collection_check_boxes(*args)
      @form_fields << Form::CollectionCheckBoxes.new(:collection_check_boxes, *args)
    end

    def collection_radio_buttons(*args)
      @form_fields << Form::CollectionRadioButtons.new(:collection_radio_buttons, *args)
    end

    def collection_select(*args)
      @form_fields << Form::CollectionSelect.new(:collection_select, *args)
    end

    def grouped_collection_select(*args)
      @form_fields << Form::GroupedCollectionSelect.new(:grouped_collection_select, *args)
    end
  end
end
