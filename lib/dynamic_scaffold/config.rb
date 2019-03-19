module DynamicScaffold
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
