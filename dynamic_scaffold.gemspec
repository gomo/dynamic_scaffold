$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dynamic_scaffold/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dynamic_scaffold"
  s.version     = DynamicScaffold::VERSION
  s.authors     = ["Masamoto Miyata"]
  s.email       = ["miyata@sincere-co.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of DynamicScaffold."
  s.description = "TODO: Description of DynamicScaffold."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"

  s.add_development_dependency "sqlite3"
end
