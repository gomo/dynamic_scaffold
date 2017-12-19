[![Build Status](https://travis-ci.org/gomo/dynamic_scaffold.svg?branch=master)](https://travis-ci.org/gomo/dynamic_scaffold)

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
  dynamic_scaffold_for 'shops'
end
```

This will generate the following routes.

```
              Prefix Verb  URI Pattern                                                                 Controller#Action
                 root GET   /                                                                          root#index
                shops GET   /shops(.:format)                                                           shops#index
                      POST  /shops(.:format)                                                           shops#create
            shops_new GET   /shops/new(.:format)                                                       shops#new
           shops_edit GET   /shops/edit(.:format)                                                      shops#edit
shops_sort_or_destroy PATCH /shops/sort_or_destroy(.:format)                                           shops#sort_or_destroy
         shops_update PATCH /shops/update(.:format)                                                    shops#update
```

### Generate controller and views

Execute the following command.

```
rails generate dynamic_scaffold shops
      create  app/controllers/shops_controller.rb
      create  app/views/shops/edit.html.erb
      create  app/views/shops/index.html.erb
      create  app/views/shops/new.html.erb
```

You can also specify namespaces and the model name.

```
rails generate dynamic_scaffold namespace/plural_model
rails generate dynamic_scaffold namespace/controller Model
```

### Prepare CSS and Javascript

You need to load dynamic_scaffold files for CSS and Javascript.　Currently, view corresponds to Bootstrap 3 and Bootstrap 4.　Please read one.

```erb
# application.html.erb
<!DOCTYPE html>
<html>
  <head>
    <title>Dummy</title>
    <%= csrf_meta_tags %>
    <%= stylesheet_link_tag    'application', media: 'all' %>
    <%= javascript_include_tag 'application' %>
    <%= render 'dynamic_scaffold/bootstrap3/head'%> # or <%= render 'dynamic_scaffold/bootstrap4/head'%>
```

### Customization

Customize each item in the block of dynamic_scaffold method.

```rb
# app/controllers/shop_controller.rb
class ShopController < ApplicationController
  include DynamicScaffold::Controller
  dynamic_scaffold Shop do |config|
    # customize here
    # `config` is DynamicScaffold::Config
  end
end
```

#### Customize list

You can customize the list through the `DynamicScaffold::Config#list` property.

```rb
# app/controllers/shop_controller.rb
class ShopController < ApplicationController
  include DynamicScaffold::Controller
  dynamic_scaffold Shop do |config|
    # First arg is attribute name of model.
    # Last hash arg is given to HTML attributes.
    # `label` method change label (I18n model attribute name is default).
    config.list.item(:id, style: 'width: 80px').label('Number')
    config.list.item :name, style: 'width: 120px'

    # If you want to call a model method, specify the block.
    config.list.item :updated_at, style: 'width: 180px' do |rec, name|
      rec.fdate name, '%Y-%m-%d %H:%M:%S'
    end

    # The `label` method also accepts block.
    config.list.item(:created_at, style: 'width: 180px').label 'Create Date' do |rec, name|
      rec.fdate name, '%Y-%m-%d %H:%M:%S'
    end

    # The first argument can also be omitted, to display item that is not model attribute.
    # The block is executed in the context of view, so you can call the method of view.
    config.list.item do |rec, name|
      link_to "Show #{rec.name}", controls_master_shops_path
    end
  end
end
```

#### Customize form

You can customize the form through the `DynamicScaffold::Config#form` property.

```rb
# app/controllers/shop_controller.rb
class ShopController < ApplicationController
  include DynamicScaffold::Controller
  dynamic_scaffold Shop do |config|
    # You can use form helper methods like ...
    # text_field, check_box, radio_button, password_field, hidden_field, file_field, text_area, color_field
    # collection_check_boxes, collection_radio_buttons, collection_select, grouped_collection_select
    config.form.hidden_field :id

    # `label` method change label from I18n model attribute name.
    config.form.text_field(:name).label 'Shop Name'

    # Last hash arg is given to HTML attributes.
    config.form.text_area :memo, rows: 8

    # Methods of the collection conform to the [ActionView::Helpers::FormBuilder](https://apidock.com/rails/ActionView/Helpers/FormBuilder) method.
    config.form.collection_select(
      :category_id, Category.all, :id, :name, include_blank: 'Select Category'
    )
    config.form.collection_check_boxes(:states, State.all, :id, :name)
    config.form.collection_radio_buttons(:status, Shop.statuses.map{|k, v| [v, k.titleize]}, :first, :last)

    config.form do |form|

    end

    # If you want to add complex HTML, you can use `content_for`.
    config.form.content_for :complex_form
    # In your view
    # <%= content_for :complex_form do %>
    #   <div></div>
    # <% end %>
  end
end
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
