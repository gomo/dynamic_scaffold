module DynamicScaffold
  class Manager
    attr_reader :model, :form, :list
    def initialize(model)
      @model = model
      @form = FormBuilder.new(self)
      @list = ListBuilder.new(self)
    end
  end

  class ListBuilder
    def initialize(manager)
      @manager = manager
      @items = []
      @sorter = nil
    end

    def sorter(params = nil)
      @sorter = params if params
      @sorter
    end

    def item(*args, &block)
      item = List::Item.new(@manager, *args, block)
      @items << item
      item
    end

    def items
      if @items.empty?
        @manager.model.column_names.each do |column|
          @items << List::Item.new(@manager, column, nil)
        end
      end
      @items
    end

    def records
      ar = @manager.model.all
      ar = ar.order @sorter if @sorter
      ar
    end

    def sorter_attribute
      @sorter.keys.first
    end

    def sorter_direction
      @sorter.values.first
    end

    def init_sequence(pkeys)
      if sorter_direction == :asc
        @sequence = 0
      elsif sorter_direction == :desc
        @sequence = pkeys.size - 1
      end
    end

    def next_sequence!
      val = @sequence
      if sorter_direction == :asc
        @sequence += 1
      elsif sorter_direction == :desc
        @sequence -= 1
      end
      val
    end

    def sorter_param(record)
      [*record.class.primary_key].map{|col| "#{col}:#{record[col]}"}.join(',')
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
        field = Form::Field::Single.new(@manager, name, *args)
        @fields << field
        field
      end
    end

    def initialize(manager)
      @manager = manager
      @fields = []
    end

    def fields
      if @fields.empty?
        @manager.model.column_names.each do |column|
          @fields << Form::Field::Single.new(@manager, :text_field, column)
        end
      end
      @fields
    end

    def collection_check_boxes(*args)
      field = Form::Field::CollectionCheckBoxes.new(@manager, :collection_check_boxes, *args)
      @fields << field
      field
    end

    def collection_radio_buttons(*args)
      field = Form::Field::CollectionRadioButtons.new(@manager, :collection_radio_buttons, *args)
      @fields << field
      field
    end

    def collection_select(*args)
      field = Form::Field::CollectionSelect.new(@manager, :collection_select, *args)
      @fields << field
      field
    end

    def grouped_collection_select(*args)
      field = Form::Field::GroupedCollectionSelect.new(@manager, :grouped_collection_select, *args)
      @fields << field
      field
    end
  end
end
