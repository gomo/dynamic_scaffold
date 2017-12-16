require 'classnames-rails-view'
module DynamicScaffold
  class Engine < ::Rails::Engine
    config.dynamic_scaffold = ActiveSupport::OrderedOptions.new
    config.dynamic_scaffold.icon_set = :font_awesome

    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.assets.precompile += %w[dynamic_scaffold/*]

    config.after_initialize do |_app|
      require 'dynamic_scaffold/active_record'
      require 'dynamic_scaffold/action_view'
      require 'dynamic_scaffold/routes'
      require "dynamic_scaffold/icon_set/#{config.dynamic_scaffold.icon_set}"
    end
  end
end
