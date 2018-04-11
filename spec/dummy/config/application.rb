require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require 'dynamic_scaffold'

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Tokyo'

    # http://davidvg.com/2010/04/06/missing-foreign-key-constraints-in-rails-test-database
    # This setting is necessary for `spec/lib/dynamic_scaffold/controllers/controls/country_controller_spec.rb#Delete`
    config.active_record.schema_format = :sql

    config.active_record.sqlite3.represent_boolean_as_integer = true
  end
end
