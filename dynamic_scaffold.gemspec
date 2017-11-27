$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'dynamic_scaffold/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'dynamic_scaffold'
  s.version     = DynamicScaffold::VERSION
  s.authors     = ['Masamoto Miyata']
  s.email       = ['miyata@sincere-co.com']
  s.homepage    = 'https://github.com/gomo/dynamic-scaffold-rails'
  s.summary     = 'Dynamic scuffold to use for production environment.'
  s.description = 'It is a scaffold for a production environment that is generated using a common HTML template.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.1.4'
  s.add_dependency 'classnames-rails-view', '~> 0.1'

  s.add_development_dependency 'classnames-rails-view', '~> 0.1'
  s.add_development_dependency 'capybara', '~> 2.13'
  s.add_development_dependency 'pry-rails', '~> 0.3'
  s.add_development_dependency 'pry-byebug', '~> 3.5'
  s.add_development_dependency 'pry-doc', '~> 0.11'
  s.add_development_dependency 'pry-stack_explorer', '~> 0.4'
  s.add_development_dependency "rspec-rails", '~> 3.7'
  s.add_development_dependency 'sqlite3', '~>1.3'
  s.add_development_dependency 'web-console', '>= 3.3.0'
  s.add_development_dependency 'listen', '>= 3.0.5', '< 3.2'
  s.add_development_dependency 'spring'
  s.add_development_dependency 'spring-watcher-listen', '~> 2.0.0'
  s.add_development_dependency 'sassc-rails', '~> 1.3'
  s.add_development_dependency 'bootstrap-sass', '~> 3'
  s.add_development_dependency 'rails-controller-testing'
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "factory_bot_rails"
end
