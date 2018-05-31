module DynamicScaffold
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
    attr_writer :name

    def initialize(config)
      @config = config
      @titles_cache = {}
      @name = @config.model.model_name.human
    end

    def name(&block)
      if block_given?
        @block = block
      elsif !@block.nil?
        @config.controller.view_context.instance_exec(&@block)
      else
        @name
      end
    end

    def current
      public_send(@config.controller.params[:action])
    end

    def index
      titles(:index)
    end

    def edit
      titles(:edit)
    end

    def new
      titles(:new)
    end

    # def update
    #   edit
    # end

    # def create
    #   create
    # end

    private

      def titles(action)
        unless @titles_cache[action]
          titles = OpenStruct.new
          titles.name = name
          titles.full = I18n.t("dynamic_scaffold.title.full.#{action}", name: titles.name)
          titles.action = I18n.t("dynamic_scaffold.title.action.#{action}")
          titles.freeze
          @titles_cache[action] = titles
        end

        @titles_cache[action]
      end
  end

  class Vars
    def initialize(config)
      @config = config
      @values = {}
    end

    def _register(name, block)
      define_singleton_method(name) do
        @values[name] ||= @config.controller.instance_exec(&block)
        @values[name]
      end
    end
  end

  class Config
    attr_reader :model, :form, :list, :title, :controller
    attr_accessor :max_count
    def initialize(model, controller)
      @model = model
      @controller = controller
      @form = FormBuilder.new(self)
      @list = ListBuilder.new(self)
      @title = Title.new(self)
      @vars = Vars.new(self)
    end

    def vars(name = nil, &block)
      if block_given?
        raise ArgumentError, 'Missing var name.' if name.nil?
        @vars._register(name, block)
      else
        @vars
      end
    end

    def scope(parameter_names = nil)
      @scope = parameter_names unless parameter_names.nil?
      @scope
    end

    def max_count?(count)
      return false if max_count.nil?
      count >= max_count
    end
  end

  class ListBuilder
    def initialize(config)
      @config = config
      @items = []
      @sorter = nil
      @order = []
      @title = nil
      @filter = nil
    end

    def pagination(options = nil)
      @pagination = Pagination.new(options) unless options.nil?

      @pagination
    end

    def page_param_name
      pagination ? pagination.param_name : nil
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

    def order(*args)
      @order = args unless args.empty?
      @order
    end

    def title(*args, &block)
      if args[0].is_a?(Symbol) || args[0].is_a?(String) || block_given?
        @title = {
          column_name: args[0],
          block: block
        }
      else
        record = args[0]
        return @config.controller.view_context.instance_exec(record, &@title[:block]) if @title[:block]
        record.public_send(@title[:column_name])
      end
    end

    def title?
      @title.present?
    end

    def build_sql(scope_params)
      sql = @config.model.all
      sql = sql.where scope_params
      sql = @config.controller.instance_exec(sql, &@filter) unless @filter.nil?
      unless sql.is_a? ::ActiveRecord::Relation
        raise(
          Error::InvalidOperation,
          'You must return ActiveRecord::Relation from filter block'
        )
      end
      sql
    end

    def filter(&block)
      @filter = block if block_given?
      @filter
    end
  end

  class FormBuilder
    def initialize(config)
      @config = config
      @items = []
      @permit_params = []
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

    def permit_params(*params)
      if !params.empty?
        @permit_params.concat(params)
        self
      else
        @permit_params
      end
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
        :color_field,
        :number_field,
        :telephone_field then
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
      when
        :carrierwave_image then
        item = Form::Item::CarrierWaveImage.new(@config, type, *args)
      else
        raise DynamicScaffold::Error::InvalidParameter, "Unknown form item type #{type}"
      end
      @items << item
      item
    end
  end
end
