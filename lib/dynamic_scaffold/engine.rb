module DynamicScaffold
  class Engine < ::Rails::Engine
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.assets.precompile += %w[dynamic_scaffold/*]
  end
end
