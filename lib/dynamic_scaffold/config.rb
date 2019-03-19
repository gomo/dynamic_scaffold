module DynamicScaffold
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
    attr_reader(
      :model,
      :form,
      :list,
      :title,
      :controller,
      :lock_before_count,
      :max_count_options,
      :scope_options
    )
    def initialize(model, controller)
      @model = model
      @controller = controller
      @form = FormBuilder.new(self)
      @list = ListBuilder.new(self)
      @title = Title.new(self)
      @vars = Vars.new(self)
      @max_count_options = {}
    end

    def vars(name = nil, &block)
      if block_given?
        raise ArgumentError, 'Missing var name.' if name.nil?

        @vars._register(name, block)
      else
        @vars
      end
    end

    def scope(*args)
      if args.present?
        @scope_options = args.extract_options!
        @scope = args[0]
      end
      @scope
    end

    def max_count(count = nil, options = nil, &block)
      @max_count = count unless count.nil?
      @max_count_options = options unless options.nil?
      @lock_before_count = block if block_given?
      @max_count
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
      @pagination = List::Pagination.new(options) unless options.nil?

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
      ret = @config.controller.instance_exec(sql, &@filter) unless @filter.nil?
      sql = ret unless ret.nil?
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

    def item(type, *args, &block)
      item = Form::Item::Base.create(@config, type, *args, &block)
      @items << item
      item
    end
  end
end
