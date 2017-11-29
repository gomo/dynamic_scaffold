module Controls
  class CountryController < ApplicationController
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
      s.add_form(:name, :text_field).description do
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
end
