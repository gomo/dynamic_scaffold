# frozen_string_literal: true

class Request::CountriesController < ApplicationController
  include DynamicScaffold::Controller
  dynamic_scaffold Country do |config|
    # If you want to use all views common variables, please call `vars`.
    # Please see https://github.com/gomo/dynamic_scaffold#view-helper for details.
    # In your view:
    # <%= dynamic_scaffold.vars.scope_target.name %>
    # here:
    # config.vars :scope_target do
    #   SomeRecord.find(params['some_record_id'])
    # end

    # You can get the current page title like `Country List`, `Edit Country` in your view.
    # <%= dynamic_scaffold.title.current.full %>
    # If you want change from the model name, set config.title.name.
    # Please see https://github.com/gomo/dynamic_scaffold#view-helper for details.
    # config.title.name = 'Model'

    # When you want a simple sort on the column of record, please call order.
    # config.list.order created_at: :desc

    # To enable sorting, call sorter method specifying the column name and direction.
    config.list.sorter sequence: :desc

    # To enable pagination, call pagination. All args is not require, defauls is below
    config.list.pagination(
      per_page: 2,
      window: 0,                # kaminari options
      outer_window: 0,          # kaminari options
      left: 0,                  # kaminari options
      right: 0,                 # kaminari options
      param_name: :page,        # kaminari options
      total_count: true,        # Whether to display total count on active page like `2 / 102`
      end_buttons: true,        # Whether to display buttons to the first and last page.
      neighbor_buttons: true,   # Whether to display buttons to the next and prev page.
      gap_buttons: false,       # Whether to display gap buttons.
      highlight_current: false # Whether to highlight the current page.
    )

    # To enable scoping, call scope with parameter names you want.
    # Please see https://github.com/gomo/dynamic_scaffold#scoping for details.
    # config.scope([role])

    # You can change the items displayed in the list through the `config.list.item`.
    # Please see https://github.com/gomo/dynamic_scaffold#customize-list for details.

    # You can set each title in the list through title method.
    # Pass the attribute name,
    # config.list.title(:name)
    # or
    # config.list.title do |record|
    #   record.name
    # end

    config.list.item(:id, style: 'width: 120px;')
    config.list.item(:name, style: 'width: 120px;')
    config.list.item(:sequence, style: 'width: 120px;')
    config.list.item(:created_at, style: 'width: 120px;')
    config.list.item(:updated_at, style: 'width: 120px;')

    # You can customize the form fields through `config.form`.
    # Please see https://github.com/gomo/dynamic_scaffold#customize-form for details.
    config.form.item(:text_field, :name)
    config.form.item(:text_field, :sequence)
    config.form.item(:text_field, :created_at)
    config.form.item(:text_field, :updated_at)
  end

  # def index
  #   super do |query|
  #     # If you want append database queries, Write here.
  #     # Do not forget to return query.
  #   end
  # end

  # def new
  #   super
  # end

  # def edit
  #   super
  # end

  # def create
  #   super do |record|
  #      # If you want to modify the attributes of the record before saving, Write here.
  #   end
  # end

  # def update
  #   super do |record, prev_attribute|
  #      # If you want to modify the attributes of the record before saving, Write here.
  #   end
  # end

  # def destroy
  #   super
  # end

  # def sort
  #   super
  # end
end
