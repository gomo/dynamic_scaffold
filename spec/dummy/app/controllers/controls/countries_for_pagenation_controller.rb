module Controls
  class CountriesForPagenationController < BaseController
    include DynamicScaffold::Controller
    dynamic_scaffold Country do |c|
      c.list.sorter id: :asc
      c.list.per_page = 1
    end
  end
end
