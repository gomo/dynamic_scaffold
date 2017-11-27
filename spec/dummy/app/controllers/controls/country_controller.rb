module Controls
  class CountryController < ApplicationController
    include DynamicScaffold::Controller
    dynamic_scaffold Country do |s|
      s.add_display(:id, style: 'width: 80px;')
      s.add_display(:name, style: 'width: 240px;')
      s.add_display(:fdate, [:updated_at, '%Y-%m-%d %H:%M:%S'], 'Update Date', style: 'width: 154px;')
      s.add_display(:fdate, [:created_at, '%Y-%m-%d %H:%M:%S'], 'Create Date', style: 'width: 154px;')
    end
  end
end
