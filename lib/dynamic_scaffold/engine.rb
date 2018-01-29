require 'classnames-rails-view'
module DynamicScaffold
  class Engine < ::Rails::Engine
    config.dynamic_scaffold = ActiveSupport::OrderedOptions.new
    config.dynamic_scaffold.icon_set = :fontawesome

    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.assets.precompile += %w[dynamic_scaffold/*]

    require 'dynamic_scaffold/routes'

    config.after_initialize do |_app|
      if Rails.application.config.dynamic_scaffold.icons.nil?
        require "dynamic_scaffold/icons/#{config.dynamic_scaffold.icon_set}"
      end
    end
  end
end
