source 'https://rubygems.org'

# Declare your gem's dependencies in dynamic_scaffold.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

group :development, :test do
  gem 'carrierwave', '~> 1.0'
  gem 'globalize', git: 'https://github.com/globalize/globalize'
  gem 'globalize-accessors'
  gem 'kaminari', '~> 1.1'
  gem 'mini_magick', '~>4.8'
  gem 'rails-controller-testing', '~> 1.0'
  gem 'sassc-rails', '~> 1.3'

  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'nokogiri', '~> 1.8'
  gem 'spring-commands-rspec'
end
