module DynamicScaffold
  class Callback
    def initialize(targets)
      @targets = targets
      @callbacks = {}
      @targets.each do |target|
        @callbacks[target] = []
      end
    end

    def add(targets, callback)
      targets.each do |target|
        check_target(target)
        @callbacks[target] << callback
      end
    end

    def call(target, controller, record, prev_attribute)
      check_target(target)
      @callbacks[target].each do |callback|
        controller.instance_exec(record, prev_attribute, &callback)
      end
    end

    private

      def check_target(target)
        return unless @callbacks[target].nil?
        
        msg = "Invalid target `#{target}` is specified. Availables: #{@targets}"
        raise DynamicScaffold::Error::InvalidParameter, msg
      end
  end
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
      @callback = Callback.new([:before_save_sort])
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

    def before_save(*args, &callback)
      @callback.add(
        args.map {|target| "before_save_#{target}".to_sym },
        callback
      )
    end

    def callbacks(target, controller, record, prev_attributes)
      @callback.call(target, controller, record, prev_attributes)
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
      @callback = Callback.new(%i[before_save_create before_save_update before_save_destroy])
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

    def before_save(*args, &callback)
      @callback.add(
        args.map {|target| "before_save_#{target}".to_sym },
        callback
      )
    end

    def callbacks(target, controller, record, prev_attributes)
      @callback.call(target, controller, record, prev_attributes)
    end
  end
end
