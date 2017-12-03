module Controls
  class CountryController < ApplicationController
    include DynamicScaffold::Controller
    dynamic_scaffold Country do |s|
      s.list.sorter sequence: :desc

      s.list.item(:id, style: 'width: 80px;')
      s.list.item(:name, style: 'width: 220px;')
      s.list.item(:updated_at, style: 'width: 162px;') do |rec, name|
        rec.fdate(name, '%Y-%m-%d %H:%M:%S')
      end
      s.list.item(:created_at, style: 'width: 162px;') do |rec, name|
        rec.fdate(name, '%Y-%m-%d %H:%M:%S')
      end
      s.list.item('To state', style: 'width: 240px;') do |rec, _name|
        content_tag :a, "To state of #{rec.name}", href: 'foobar'
      end

      s.form.hidden_field(:id)
      s.form.text_field(:name).note do
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
