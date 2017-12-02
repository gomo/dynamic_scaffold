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

Please specify the path you want to the `dynamic_scaffold_for` method.

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

### Customization

Customization of each item is done by passing the dynamic_scaffold method block inside it.

```rb
# app/controllers/shop_controller.rb
class ShopController < ApplicationController
  include DynamicScaffold::Controller
  dynamic_scaffold Shop do |m|
    # customize here
    # `m` is DynamicScaffold::Manager
  end
end
```

#### Customize list

We customize the list page through the `DynamicScaffold::Manager#list` property.

```rb
# app/controllers/shop_controller.rb
class ShopController < ApplicationController
  include DynamicScaffold::Controller
  dynamic_scaffold Shop do |m|
    # First arg is attribute name of model.
    # Last hash arg is given to HTML attributes.
    # `label` method change label from I18n model attribute name.
    m.list.item(:id, style: 'width: 80px').label('Number')
    m.list.item :name, style: 'width: 120px'

    # If you want to call a model method that requires arguments please block.
    m.list.item :updated_at, style: 'width: 180px' do |rec, name|
      rec.fdate name, '%Y-%m-%d %H:%M:%S'
    end

    # The `label` method also accepts block, so you can change it.
    m.list.item(:created_at, style: 'width: 180px').label 'Create Date' do |rec, name|
      rec.fdate name, '%Y-%m-%d %H:%M:%S'
    end

    # The first argument can also be omitted to display item that is not model attribute.
    # The block is executed in the context of view, so you can call the method of view.
    m.list.item do |rec, name|
      link_to "Show #{rec.name}", controls_master_shop_path
    end
  end
end
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
