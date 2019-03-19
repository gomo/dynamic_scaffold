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
end