# DynamicScaffold
Scaffold which dynamically generates CRUD using a common view.

Once the view is built in, it can be used with multiple models. In addition, you can flexibly customize the items displayed by model.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'dynamic_scaffold'
```

And then execute:
```bash
$ bundle
```

## Usage

### Routes

```rb
# config/routes.rb
Rails.application.routes.draw do
  dynamic_scaffold_for 'shop'
end
```

This will generate the following routes.

```
  Prefix Verb URI Pattern                                    Controller#Action
    shop GET  /shop(.:format)                                 shop#index {:trailing_slash=>true}
shop_new GET  /shop/new(.:format)                             shop#new
```


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
