module Controls
  class ShopController < ApplicationController
    include DynamicScaffold::Controller
    dynamic_scaffold Country do |s|
      s.add_display(:id, style: 'width: 80px;')
      s.add_display(:name, style: 'width: 220px;')
      s.add_display(:fdate, [:updated_at, '%Y-%m-%d %H:%M:%S'], 'Update Date', style: 'width: 162px;')
      s.add_display(:fdate, [:created_at, '%Y-%m-%d %H:%M:%S'], 'Create Date', style: 'width: 162px;')
      s.add_display('To state', style: 'width: 240px;') do |record|
        content_tag :a, "To state of #{record.name}", href: 'foobar'
      end

      s.add_form(:id, :hidden_field)
      s.add_form(:name, :text_field)
      s.add_form(:memo, :text_area, rows: 10)
      s.add_form(:states, :check_boxes, State.all, :id, :name, 'States')
    end
  end
end
