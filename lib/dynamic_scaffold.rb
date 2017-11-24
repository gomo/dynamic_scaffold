require 'active_support/dependencies'
require "dynamic_scaffold/engine"

module DynamicScaffold
  autoload :Controller, 'dynamic_scaffold/controller'
  autoload :Manager, 'dynamic_scaffold/manager'
end
