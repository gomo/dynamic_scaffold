module DynamicScaffold
  class Config
    attr_reader :model, :form, :list
    def initialize(model)
      @model = model
      @form = FormBuilder.new(self)
      @list = ListBuilder.new(self)

      @callback_targets = %i[create update destroy sort].freeze
      @before_save_callbacks = {}
      @callback_targets.each do |target|
        @before_save_callbacks[target] = []
      end
      @before_save_callbacks.freeze
    end

    def scope(parameter_names = nil)
      @scope = parameter_names unless parameter_names.nil?
      @scope
    end

    def before_save(*args, &callback)
      callback = args.shift if callback.nil?
      targets = args
      targets.each do |target|
        @before_save_callbacks[target] << callback
      end
    end

    def call_before_save(target, controller, *args)
      if @before_save_callbacks[target].nil?
        msg = "Invalid target `#{target}` is specified. Availables: #{@callback_targets}"
        raise DynamicScaffold::Error::InvalidParameter, msg
      end

      @before_save_callbacks[target].each do |callback|
        if callback.is_a? Proc
          controller.instance_exec(*args, &callback)
        else
          controller.send(callback, *args)
        end
      end
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
          type = :text_field
          type = :hidden_field if @config.scope && @config.scope.include?(column.to_sym)
          @fields << Form::Field::Single.new(@config, type, column)
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

    def content_for(*args)
      field = Form::Field::ContentFor.new(@config, :content_for, *args)
      @fields << field
      field
    end
  end
end
