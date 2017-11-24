$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dynamic_scaffold/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dynamic_scaffold"
  s.version     = DynamicScaffold::VERSION
  s.authors     = ["Masamoto Miyata"]
  s.email       = ["miyata@sincere-co.com"]
  s.homepage    = "https://github.com/gomo/dynamic-scaffold-rails"
  s.summary     = "Dynamic scuffold to use for production environment."
  s.description = "It is a scaffold for a production environment that is generated using a common HTML template."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'pry-doc'
  s.add_development_dependency 'pry-rails'
  s.add_development_dependency 'pry-stack_explorer'
  s.add_development_dependency 'rails-controller-testing'
  s.add_development_dependency 'rspec-rails'
end
