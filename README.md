[![Build Status](https://travis-ci.org/gomo/dynamic_scaffold.svg?branch=master)](https://travis-ci.org/gomo/dynamic_scaffold)

# DynamicScaffold
Scaffold which dynamically generates CRUD and sort.

## Feature

* It is generated dynamically.
* Responsive design and touch UI.
* Support sort and pagination.
* Has simple view using bootstrap. Support bootstrap3/4.
* Customizable and flexible.

<img src="images/list_with_pager.png">


<img src="images/form.png">



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
# app/controllers/shops_controller.rb
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
# app/controllers/shops_controller.rb
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
# app/controllers/shops_controller.rb
class ShopController < ApplicationController
  include DynamicScaffold::Controller
  dynamic_scaffold Shop do |config|
    # You can use form helper methods like ...
    # text_field, check_box, radio_button, password_field, hidden_field, file_field, text_area, color_field
    # collection_check_boxes, collection_radio_buttons, collection_select, grouped_collection_select

    # Default label is I18n model attribute name.
    config.form.text_field :name
    # You can specify `label`. 
    config.form.text_field(:name).label 'Shop Name'

    # If you use hidden_field, the label will also be hidden.
    config.form.hidden_field :id
    # but if you specify the label explicitly it will be displayed.
    config.form.hidden_field(:id).label 'ID'

    # Last hash arg is given to HTML attributes.
    config.form.text_area :memo, rows: 8

    # Methods of the collection conform to the [ActionView::Helpers::FormBuilder](https://apidock.com/rails/ActionView/Helpers/FormBuilder) method.
    config.form.collection_select(
      :category_id, Category.all, :id, :name, include_blank: 'Select Category'
    )
    config.form.collection_check_boxes(:states, State.all, :id, :name)
    config.form.collection_radio_buttons(:status, Shop.statuses.map{|k, v| [v, k.titleize]}, :first, :last)

    # If you want to display more free form field, use block.
    # The block is executed in the context of view, so you can call the method of view.
    config.form.block :free do |form, field|
      content_tag :div, class: 'foobar' do
        form.text_field field.name, class: 'foobar'
      end
    end

    # The label of block method also accepts block.
    config.form.block(:free).label 'Free Value' do |form, field|
      content_tag :div, class: 'foobar' do
        form.text_field field.name, class: 'foobar'
      end
    end

    # You can also add a note to the form field.
    config.form.text_field(:name).note do
      content_tag :p do
        out = []
        out << 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
        out << 'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
        out << tag(:br)
        out << 'Ut enim ad minim veniam, quis nostrud exercitation ullamco '
        out << 'laboris nisi ut aliquip ex ea commodo consequat. '
        out << tag(:br)
        safe_join(out)
      end
    end
  end
end
```

### Sorting

You can sort records having integer column for order in the list page.

```rb
class CreateCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :countries do |t|
      t.string :name
      t.integer :sequence
    end
  end
end
```

```
rails generate dynamic_scaffold countries
```

```rb
# app/controllers/countries_controller.rb
class CountriesController < ApplicationController
  include DynamicScaffold::Controller
  dynamic_scaffold Country do |config|
    config.list.sorter sequence: :desc
    ...
```

<img src="images/sorter.gif">

### Pagination

You can enable pagination with [kaminari](https://github.com/kaminari/kaminari).

```rb
# app/controllers/shops_controller.rb
class ShopController < ApplicationController
  include DynamicScaffold::Controller
  dynamic_scaffold Shop do |config|
    config.list.pagination per_page: 20
    ...
```

The following options are available for the pagination.

```
window: 0,                # kaminari options
outer_window: 0,          # kaminari options
left: 0,                  # kaminari options
right: 0,                 # kaminari options
param_name: :page,        # kaminari options
total_count: true,        # Whether to display total count on active page like `2 / 102`
end_buttons: true,        # Whether to display buttons to the first and last page.
neighbor_buttons: true,   # Whether to display buttons to the next and prev page.
gap_buttons: false,       # Whether to display gap buttons.
highlight_current: false, # Whether to highlight the current page.
```

### Scoping

You can scoping by url param.

For example, you create a scaffold for a user table with a roll column on a separate page for each role.

```rb
create_table :users do |t|
  t.string :email, null: false
  t.string :encrypted_password, null: false
  t.integer :role, limit: 2, null: false
end

class User < ApplicationRecord
  enum role: { admin: 1, staff: 2, member: 3 }
end
```

Set the route as follows.

```rb
Rails.application.routes.draw do
  dynamic_scaffold_for 'users/:role', controller: 'users', role: Regexp.new(User.roles.keys.join('|'))
end
```

```
                users GET   /users/:role(.:format)                    users#index {:role=>/admin|staff|member/}
                      POST  /users/:role(.:format)                    users#create {:role=>/admin|staff|member/}
            users_new GET   /users/:role/new(.:format)                users#new {:role=>/admin|staff|member/}
           users_edit GET   /users/:role/edit(.:format)               users#edit {:role=>/admin|staff|member/}
users_sort_or_destroy PATCH /users/:role/sort_or_destroy(.:format)    users#sort_or_destroy {:role=>/admin|staff|member/}
         users_update PATCH /users/:role/update(.:format)             users#update {:role=>/admin|staff|member/}
```

For the controller, as follows.

```rb
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  include DynamicScaffold::Controller
  dynamic_scaffold User do |c|
    c.scope [:role]
    ...
```


### View helper

You can get the current page title like `Country List`, `Edit Country` in your view.

```erb
# app/views/your_view.html.erb
<h1><%= current_page  %></h1>
```

If you want change from the model name, set title.

```rb
# app/controllers/shops_controller.rb
class ShopController < ApplicationController
  include DynamicScaffold::Controller
  dynamic_scaffold Shop do |config|
    config.title.name = 'Model'
    ...
```

You can get the title and link of each action.

```erb
<ol class="breadcrumb">
  <% if params['action'] == 'index' %>
    <li class="active"><%= dynamic_scaffold.title.index %></li>
  <% else %>
    <li><%= link_to dynamic_scaffold.title.index, dynamic_scaffold_path(:index) %></li>
    <li class="active"><%= current_title %></li>
  <% end %>
</ol>
```

## Contributing

* We use rspec for test.
* Check code with [rubocop](https://github.com/bbatsov/rubocop).

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
