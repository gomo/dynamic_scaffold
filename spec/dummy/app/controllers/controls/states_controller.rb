class Controls::StatesController < Controls::BaseController
  include DynamicScaffold::Controller
  dynamic_scaffold State do |config|
    # To enable sorting, call sorter method specifying the column name and direction.
    # config.list.sorter sequence: :desc

    # To enable pagination, call pagination. All args is not require, defauls is below
    config.list.pagination(
      per_page: 1,
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

    # You can change the items displayed in the list through the `config.list.item`.
    # Please see https://github.com/gomo/dynamic_scaffold#customize-list for details.
    config.list.item(:id, style: 'width: 120px;')
    config.list.item(:name, style: 'width: 120px;')
    config.list.item(:sequence, style: 'width: 120px;')
    config.list.item(:country_id, style: 'width: 120px;')
    config.list.item(:created_at, style: 'width: 120px;')
    config.list.item(:updated_at, style: 'width: 120px;')

    # You can customize the form fields through `config.form`.
    # Please see https://github.com/gomo/dynamic_scaffold#customize-form for details.
    config.form.item(:text_field, :id)
    config.form.item(:text_field, :name)
    config.form.item(:text_field, :sequence)
    config.form.item(:text_field, :country_id)
    config.form.item(:text_field, :created_at)
    config.form.item(:text_field, :updated_at)
  end

  # def index
  #   super
  # end

  # def new
  #   super
  # end

  # def edit
  #   super
  # end

  # def create
  #   super
  # end

  # def update
  #   super
  # end

  # def destroy
  #   super
  # end

  # def sort
  #   super
  # end
end
