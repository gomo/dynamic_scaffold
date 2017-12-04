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
      @dynamic_scaffold = manager
      @items = []
      @sorter = nil
    end

    def sorter(params = nil)
      @sorter = params if params
      @sorter
    end

    def item(*args, &block)
      item = List::Item.new(@dynamic_scaffold, *args, block)
      @items << item
      item
    end

    def items
      if @items.empty?
        @dynamic_scaffold.model.column_names.each do |column|
          @items << List::Item.new(@dynamic_scaffold, column, nil)
        end
      end
      @items
    end

    def records
      ar = @dynamic_scaffold.model.all
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
      [*record.class.primary_key].map {|col| "#{col}:#{record[col]}" }.join(',')
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
        field = Form::Field::Single.new(@dynamic_scaffold, name, *args)
        @fields << field
        field
      end
    end

    def initialize(manager)
      @dynamic_scaffold = manager
      @fields = []
    end

    def fields
      if @fields.empty?
        @dynamic_scaffold.model.column_names.each do |column|
          @fields << Form::Field::Single.new(@dynamic_scaffold, :text_field, column)
        end
      end
      @fields
    end

    def collection_check_boxes(*args)
      field = Form::Field::CollectionCheckBoxes.new(@dynamic_scaffold, :collection_check_boxes, *args)
      @fields << field
      field
    end

    def collection_radio_buttons(*args)
      field = Form::Field::CollectionRadioButtons.new(@dynamic_scaffold, :collection_radio_buttons, *args)
      @fields << field
      field
    end

    def collection_select(*args)
      field = Form::Field::CollectionSelect.new(@dynamic_scaffold, :collection_select, *args)
      @fields << field
      field
    end

    def grouped_collection_select(*args)
      field = Form::Field::GroupedCollectionSelect.new(@dynamic_scaffold, :grouped_collection_select, *args)
      @fields << field
      field
    end
  end
end
