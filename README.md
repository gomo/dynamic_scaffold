# DynamicScaffold
The Scaffold system which dynamically generates CRUD and sort functions.

## Feature

* This is generate the pages using same views dynamically.
* Support the responsive design and touch UI.
* Support sort and pagination.
* This has the views with the Twitter Bootstrap. Support bootstrap3/4.
* Customizable and flexible.

<img src="images/list_with_pager.png">


<img src="images/form.png">



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dynamic_scaffold', '~> 0.1'
```

And then execute:
```bash
$ bundle
```

## Usage

### Routes

Please call `dynamic_scaffold_for` method with the resource name.

```rb
# config/routes.rb
Rails.application.routes.draw do
  dynamic_scaffold_for 'shops'
end
```

This will generate the following routes.

```
sort_or_destroy_controls_master_shops PATCH /:locale/controls/master/shops/sort_or_destroy(.:format)     controls/shops#sort_or_destroy
                controls_master_shops GET   /:locale/controls/master/shops(.:format)                     controls/shops#index
                                      POST  /:locale/controls/master/shops(.:format)                     controls/shops#create
             new_controls_master_shop GET   /:locale/controls/master/shops/new(.:format)                 controls/shops#new
            edit_controls_master_shop GET   /:locale/controls/master/shops/:id/edit(.:format)            controls/shops#edit
                 controls_master_shop PATCH /:locale/controls/master/shops/:id(.:format)                 controls/shops#update
                                      PUT   /:locale/controls/master/shops/:id(.:format)                 controls/shops#update
```

### Generate controller and views

First, you need a model of the target table. If you have not generate it yet, please generate the model.

```
rails generate model Shop
```

Next, execute the following command for generate the controller and views.

```
rails generate dynamic_scaffold shops
      create  app/controllers/shops_controller.rb
      create  app/views/shops/edit.html.erb
      create  app/views/shops/index.html.erb
      create  app/views/shops/new.html.erb
```

You can also specify namespaces and the model name if you want.

```
rails generate dynamic_scaffold namespace/plural_model
rails generate dynamic_scaffold namespace/controller Model
```

#### Options

##### content_for

Enclose the `render` of view in `content_for`.

```
rails generate dynamic_scaffold admin/shops --content_for admin_body
```

```erb
# views/admin/shops/edit.html.erb
<% content_for :admin_body do%>
  <%= render 'dynamic_scaffold/bootstrap/edit' %>
<%end%>
```

##### controller_base

Change the base class of controller.

```
rails generate dynamic_scaffold admin/shops --controller_base Admin::BaseController
```

```erb
# controllers/admin/shops_controller.rb
class Admin::ShopsController < Admin::BaseController
  include DynamicScaffold::Controller
  dynamic_scaffold Shop do |config|
```


### Prepare CSS and Javascript

You need to load the files for CSS and Javascript.　Currently, we support the Bootstrap 3 and Bootstrap 4.

```sass
# app/assets/stylesheets/application.scss
@import 'dynamic_scaffold/bootstrap3'
# or
@import 'dynamic_scaffold/bootstrap4'
```

```js
// app/assets/javascripts/application.js
//= require dynamic_scaffold
```

### Customization

You can customize each items in the block passed as dynamic_scaffold method argument.

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
    # You can set each title in the list through title method.
    # Pass the attribute name,
    # config.list.title(:name)
    # or
    # config.list.title do |record|
    #   record.name
    # end
  
    # First arg is attribute name of model.
    # Last hash arg is given to HTML attributes options.
    # `label` method change the label (I18n model attribute name is default).
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
    # config.form.item(type, name, html_attributes)
    # or
    # config.form.item(type, name, options, html_attributes)
    #
    # You can use form helper methods for type,
    # text_field, check_box, radio_button, password_field, hidden_field, file_field, text_area, color_field,
    # collection_check_boxes, collection_radio_buttons, collection_select, grouped_collection_select,
    # time_select, date_select, datetime_select


    # Default label is I18n model attribute name.
    config.form.item :text_field, :name
    # You can specify `label`. 
    config.form.item(:text_field, :name).label 'Shop Name'
    # You can set default value for new action.
    config.form.item(:text_field, :name).default('Foo Bar')

    # If you use hidden_field, the label will also be hidden.
    config.form.item :hidden_field, :id
    # but if you specify the label explicitly it will be displayed.
    config.form.item(:hidden_field, :id).label 'ID'

    # Last hash arg is given to HTML attributes.
    config.form.item :text_area, :memo, rows: 8

    # Methods of the collection conform to the [ActionView::Helpers::FormBuilder](https://apidock.com/rails/ActionView/Helpers/FormBuilder) method.
    config.form.item(:collection_select, 
      :category_id, Category.all, :id, :name, include_blank: 'Select Category'
    )
    config.form.item(:collection_check_boxes, :state_ids, State.all, :id, :name)
    config.form.item(:collection_radio_buttons, :status, Shop.statuses.map{|k, _v| [k, k.titleize]}, :first, :last)

    # You can add an image uploader with preview to the form. The save and remove part to the model corresponds to [carrierwave](https://github.com/carrierwaveuploader/carrierwave).
    # In the example below, you need to mount the carrierwave uploader on the thumb column of the model.
    #
    # class Shop < ApplicationRecord
    #   mount_uploader :thumb, ShopThumbUploader
    #
    config.form.item(:carrierwave_image, :thumb, preview_max_size: {width: '300px', height: '300px'})

    # If you want to display more free form field, use block.
    # The block is executed in the context of view, so you can call the method of view.
    config.form.item :block, :free do |form, field|
      content_tag :div, class: 'foobar' do
        form.text_field field.name, class: 'foobar'
      end
    end

    # The label of block method also accepts block.
    config.form.item(:block, :free).label 'Free Value' do |form, field|
      content_tag :div, class: 'foobar' do
        form.text_field field.name, class: 'foobar'
      end
    end

    # You can insert HTML before/after the element.
    config.form.item(:file_field, :image).label('Image').insert(:after) do |rec|
      tag.label for: :delete_image do
        concat tag.input type: :checkbox, id: :delete_image, name: 'shop[delete_image]'
        concat 'Delete image'
      end
    end

    # You need to permit the new form parameters you inserted.
    # And if necessary, add virtual attributes to the model.
    config.form.permit_params(:delete_image)

    # You can also add a note to the form field.
    config.form.item(:text_field, :name).note do
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
total_count: true,        # Whether to display total count and active page, like `2/102`.
end_buttons: true,        # Whether to display buttons to the first and last page.
neighbor_buttons: true,   # Whether to display buttons to the next and prev page.
gap_buttons: false,       # Whether to display gap buttons.
highlight_current: false, # Whether to highlight the current page.
```

### Scoping

You can scoping for target items by url param.

For example, you create the Scaffold of users for each role.
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
  dynamic_scaffold_for 'users/:role', controller: 'users', as: 'users', role: Regexp.new(User.roles.keys.join('|'))
end
```

```
sort_or_destroy_controls_master_users PATCH /:locale/controls/master/users/:role/sort_or_destroy(.:format)  controls/users#sort_or_destroy {:role=>/admin|staff|member/}
                controls_master_users GET   /:locale/controls/master/users/:role(.:format)                  controls/users#index {:role=>/admin|staff|member/}
                                      POST  /:locale/controls/master/users/:role(.:format)                  controls/users#create {:role=>/admin|staff|member/}
             new_controls_master_user GET   /:locale/controls/master/users/:role/new(.:format)              controls/users#new {:role=>/admin|staff|member/}
            edit_controls_master_user GET   /:locale/controls/master/users/:role/:id/edit(.:format)         controls/users#edit {:role=>/admin|staff|member/}
                 controls_master_user PATCH /:locale/controls/master/users/:role/:id(.:format)              controls/users#update {:role=>/admin|staff|member/}
                                      PUT   /:locale/controls/master/users/:role/:id(.:format)              controls/users#update {:role=>/admin|staff|member/}
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

#### dynamic_scaffold.title


You can set and get the title of the pages.


```erb
# app/views/your_resources/list.html.erb
<%= dynamic_scaffold.title.current.name %>
<!-- Shop -->

<%= dynamic_scaffold.title.current.action %>
<!-- List -->

<%= dynamic_scaffold.title.current.full %>
<!-- Shop List -->
```

You can get another action title through the action name method too.

```erb
# app/views/your_resources/list.html.erb
<%= dynamic_scaffold.title.new.full %>
<!-- Create Shop -->
```

If you want change from the model name, set `config.title.name`.

```rb
# app/controllers/shops_controller.rb
class ShopController < ApplicationController
  include DynamicScaffold::Controller
  dynamic_scaffold Shop do |config|
    config.title.name = 'Model'
    ...
```

If you want to dynamically set according to url parameters, you can also use block.

```rb
# app/controllers/shops_controller.rb
class ShopController < ApplicationController
  include DynamicScaffold::Controller
  dynamic_scaffold Shop do |config|
    config.title.name do |params|
      I18n.t "enum.user.role.#{params[role]}", default: params[role].titleize
    end
```

#### dynamic_scaffold_path

You can get the path by specifying the action name. Below is an example of displaying breadcrumbs.

```erb
<ol class="breadcrumb">
  <%= yield :breadcrumb_before %>
  <% if params['action'] == 'index' %>
    <li class="active"><%= dynamic_scaffold.title.current.name %></li>
  <% else %>
    <li><%= link_to dynamic_scaffold.title.index.name, dynamic_scaffold_path(:index) %></li>
    <li class="active"><%= dynamic_scaffold.title.current.action %></li>
  <% end %>
</ol>
```

#### dynamic_scaffold.vars

You can cache, such as data to be displayed multiple times in a view using `dynamic_scaffold.vars`.

```rb
# app/controllers/shops_controller.rb
class ShopController < ApplicationController
  include DynamicScaffold::Controller
  dynamic_scaffold Shop do |config|
    config.title.vars :shop_type do
      ShopType.find(params['shop_type_id'])
    end
    ...
```

```rb
# in your view
<%= dynamic_scaffold.vars.shop_type.name %>
```

### Password Handling Tips

Passwords are not displayed on the editing screen and should be skipped　validation when sent with empty.

You can do it by preparing virtual attributes for the edit action, and switching between edit and new action.

```rb
class User < ApplicationRecord
  validates :password, presence: true

  attr_reader :password_edit

  def password_edit=(value)
    @password_edit = value
    self.password = value if value.present?
  end
end
```

```rb
class UsersController < ScaffoldController
  include DynamicScaffold::Controller
  dynamic_scaffold User do |config|

    # If the block given to the `if` method returns false, the element is ignored.
    # The block argument is `params` in controller.
    config.form.item(:password_field, :password)
      .if {|p| %w[new create].include? p[:action] }

    # When you call the `proxy` method, the element's error messages and label will be used for the specified attribute.
    config.form.item(:password_field, :password_edit)
      .proxy(:password)
      .if {|p| %w[edit update].include? p[:action] }
  end
end
```


## Contributing

* We use rspec for test.
* Check code with [rubocop](https://github.com/bbatsov/rubocop).
* You can change CSS to Bootstrap3 by registering `bootstrap=3` in cookie in the sample page.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).