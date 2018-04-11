$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'dynamic_scaffold/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'dynamic_scaffold'
  s.version     = DynamicScaffold::VERSION
  s.authors     = ['Masamoto Miyata']
  s.email       = ['miyata@sincere-co.com']
  s.homepage    = 'https://github.com/gomo/dynamic_scaffold'
  s.summary     = 'The Scaffold system which dynamically generates CRUD and sort functions.'
  s.description = 'It is customizable and flexible scaffold who support sort and the pagination.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'classnames-rails-view', '>= 0.1'
  s.add_dependency 'kaminari', '>= 1.0'
  s.add_dependency 'rails', '>= 5.0', '< 5.3'

  s.add_development_dependency 'capybara', '~> 2.13'
  s.add_development_dependency 'database_cleaner', '~> 1.6'
  s.add_development_dependency 'factory_bot_rails', '~> 4.8'
  s.add_development_dependency 'faker', '~> 1.8'
  s.add_development_dependency 'pry-byebug', '~> 3.5'
  s.add_development_dependency 'pry-doc', '~> 0.11'
  s.add_development_dependency 'pry-rails', '~> 0.3'
  s.add_development_dependency 'pry-stack_explorer', '~> 0.4'
  s.add_development_dependency 'rspec-rails', '~> 3.7'
  s.add_development_dependency 'sqlite3', '~>1.3'
end
