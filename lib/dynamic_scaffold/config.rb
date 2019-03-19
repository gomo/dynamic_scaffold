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
end
