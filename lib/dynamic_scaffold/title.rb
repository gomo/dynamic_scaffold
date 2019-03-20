module DynamicScaffold
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

    def update
      titles(:edit)
    end

    def create
      titles(:new)
    end

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
end
