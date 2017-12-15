module Controls
  class CountriesForPagenationController < BaseController
    include DynamicScaffold::Controller
    dynamic_scaffold Country do |c|
      c.list.sorter id: :asc
      c.list.pagenation(
        per_page: 1,
        window: 5,
        outer_window: 1,
        gap_buttons: true,
        total_count: false,
        end_buttons: false,
        highlight_current: true,
        param_name: :foobar
      )
    end
  end
end
