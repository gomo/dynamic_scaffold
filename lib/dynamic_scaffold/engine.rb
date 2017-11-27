module DynamicScaffold
  class Engine < ::Rails::Engine
    config.dynamic_scaffold = ActiveSupport::OrderedOptions.new
    config.dynamic_scaffold.up_icon = '<i class="fa fa-chevron-up"></i>'.html_safe
    config.dynamic_scaffold.down_icon = '<i class="fa fa-chevron-down"></i>'.html_safe
    config.dynamic_scaffold.delete_icon = '<i class="fa fa-times"></i>'.html_safe
    config.dynamic_scaffold.edit_icon = '<i class="fa fa-pencil"></i>'.html_safe

    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.assets.precompile += %w[dynamic_scaffold/*]

    config.after_initialize do |_app|
      require 'dynamic_scaffold/action_view'
    end
  end
end
