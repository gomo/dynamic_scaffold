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

    def call(target, controller, *args)
      check_target(target)
      result = nil
      @callbacks[target].each do |callback|
        result = controller.instance_exec(*args, &callback)
      end
      result
    end

    def exists?(target)
      !@callbacks[target].empty?
    end

    private

      def check_target(target)
        return unless @callbacks[target].nil?

        msg = "Invalid target `#{target}` is specified. Availables: #{@targets}"
        raise DynamicScaffold::Error::InvalidParameter, msg
      end
  end

  class Pagination
    attr_reader(
      :kaminari_options,
      :per_page,
      :total_count,
      :end_buttons,
      :neighbor_buttons,
      :gap_buttons,
      :highlight_current,
      :param_name
    )
    def initialize(options)
      options = {
        per_page: 25,
        window: 0,                # kaminari options
        outer_window: 0,          # kaminari options
        left: 0,                  # kaminari options
        right: 0,                 # kaminari options
        param_name: :page,        # kaminari options
        total_count: true,        # Whether to display total count on active page like `2 / 102`
        end_buttons: true,        # Whether to display buttons to the first and last page.
        neighbor_buttons: true,   # Whether to display buttons to the next and prev page.
        gap_buttons: false,       # Whether to display gap buttons.
        highlight_current: false, # Whether to highlight the current page.
      }.merge(options)
      @kaminari_options = options.extract!(:window, :outer_window, :left, :right, :param_name)
      @param_name = @kaminari_options[:param_name]
      options.each {|name, value| instance_variable_set("@#{name}", value) }
    end

    def page_number(page, records)
      return page unless total_count
      "#{page} / #{records.total_pages}"
    end

    def page_class(page, _records)
      if page.inside_window?
        'inner'
      elsif page.left_outer?
        'left-outer'
      elsif page.right_outer?
        'right-outer'
      end
    end
  end

  class Title
    def initialize(name)
      @name = name
    end

    attr_writer :name

    def name(view = nil, &block)
      @block = block if block_given?
      return self unless view

      # getter
      return view.instance_exec(view.controller.params, &@block) unless @block.nil?
      @name
    end

    def index(view)
      I18n.t('dynamic_scaffold.title.index', model: name(view))
    end

    def edit(view)
      I18n.t('dynamic_scaffold.title.edit', model: name(view))
    end

    def update(view)
      I18n.t('dynamic_scaffold.title.edit', model: name(view))
    end

    def new(view)
      I18n.t('dynamic_scaffold.title.new', model: name(view))
    end

    def create(view)
      I18n.t('dynamic_scaffold.title.new', model: name(view))
    end
  end

  class Config
    attr_reader :model, :form, :list, :title
    def initialize(model)
      @model = model
      @form = FormBuilder.new(self)
      @list = ListBuilder.new(self)
      @title = Title.new(@model.model_name.human)
    end

    def scope(parameter_names = nil)
      @scope = parameter_names unless parameter_names.nil?
      @scope
    end
  end

  class ListBuilder
    attr_reader :callback

    def initialize(config)
      @config = config
      @items = []
      @sorter = nil
      @callback = Callback.new(%i[before_save_sort before_fetch])
    end

    def pagination(options = nil)
      @pagination = Pagination.new(options) unless options.nil?

      @pagination
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

    def before_fetch(&callback)
      @callback.add(
        [:before_fetch],
        callback
      )
    end

    def before_save(*args, &callback)
      @callback.add(
        args.map {|target| "before_save_#{target}".to_sym },
        callback
      )
    end
  end

  class FormBuilder
    attr_reader :callback

    def initialize(config)
      @config = config
      @items = []
      @callback = Callback.new(%i[before_save_create before_save_update before_save_destroy])
    end

    def items
      if @items.empty?
        @config.model.column_names.each do |column|
          type = :text_field
          type = :hidden_field if @config.scope && @config.scope.include?(column.to_sym)
          @items << Form::Item::SingleOption.new(@config, type, column)
        end
      end
      @items
    end

    def item(type, *args, &block) # rubocop:disable Metrics/MethodLength
      case type
      when
        :check_box,
        :radio_button,
        :text_area,
        :text_field,
        :password_field,
        :hidden_field,
        :file_field,
        :color_field then
        item = Form::Item::SingleOption.new(@config, type, *args)
      when
        :time_select,
        :date_select,
        :datetime_select,
        :collection_select,
        :grouped_collection_select then
        item = Form::Item::TwoOptions.new(@config, type, *args)
      when
        :collection_check_boxes,
        :collection_radio_buttons then
        item = Form::Item::TwoOptionsWithBlock.new(@config, type, *args)
      when
        :block then
        item = Form::Item::Block.new(@config, type, *args, block)
      else
        raise DynamicScaffold::Error::InvalidParameter, "Unknown form item type #{type}"
      end
      @items << item
      item
    end

    def before_save(*args, &callback)
      @callback.add(
        args.map {|target| "before_save_#{target}".to_sym },
        callback
      )
    end
  end
end
