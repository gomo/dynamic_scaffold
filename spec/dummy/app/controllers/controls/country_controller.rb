module Controls
  class CountryController < ApplicationController
    include DynamicScaffold::Controller
    dynamic_scaffold Country do |s|
      s.add_display(:id, style: 'width: 80px;')
      s.add_display(:name, style: 'width: 240px;')
      s.add_display(:fdate, [:updated_at, '%Y-%m-%d %H:%M:%S'], 'Update Date', style: 'width: 162px;')
      s.add_display(:fdate, [:created_at, '%Y-%m-%d %H:%M:%S'], 'Create Date', style: 'width: 162px;')

      s.add_form(:id, :hidden_field)

      s.add_form(:name, :text_field).description = <<-DESC.html_safe
        blah [option] {file}<br>
        --version show version<br>
        --help    show this help<br>
      DESC
    end
  end
end
