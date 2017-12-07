module DynamicScaffold
  class Config
    attr_reader :model, :form, :list
    def initialize(model)
      @model = model
      @form = FormBuilder.new(self)
      @list = ListBuilder.new(self)
    end

    def scope(parameter_names = nil)
      @scope = parameter_names unless parameter_names.nil?
      @scope
    end
  end

  class ListBuilder
    def initialize(config)
      @config = config
      @items = []
      @sorter = nil
    end

    def sorter(params = nil)
      @sorter = params if params
      @sorter
    end

    def item(*args, &block)
      item = List::Item.new(@config, *args, block)
      @items << item
      item
    end

    def items
      if @items.empty?
        @config.model.column_names.each do |column|
          @items << List::Item.new(@config, column, nil)
        end
      end
      @items
    end

    def sorter_attribute
      @sorter.keys.first
    end

    def sorter_direction
      @sorter.values.first
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
        field = Form::Field::Single.new(@config, name, *args)
        @fields << field
        field
      end
    end

    def initialize(config)
      @config = config
      @fields = []
    end

    def fields
      if @fields.empty?
        @config.model.column_names.each do |column|
          @fields << Form::Field::Single.new(@config, :text_field, column)
        end
      end
      @fields
    end

    def collection_check_boxes(*args)
      field = Form::Field::CollectionCheckBoxes.new(@config, :collection_check_boxes, *args)
      @fields << field
      field
    end

    def collection_radio_buttons(*args)
      field = Form::Field::CollectionRadioButtons.new(@config, :collection_radio_buttons, *args)
      @fields << field
      field
    end

    def collection_select(*args)
      field = Form::Field::CollectionSelect.new(@config, :collection_select, *args)
      @fields << field
      field
    end

    def grouped_collection_select(*args)
      field = Form::Field::GroupedCollectionSelect.new(@config, :grouped_collection_select, *args)
      @fields << field
      field
    end
  end
end
