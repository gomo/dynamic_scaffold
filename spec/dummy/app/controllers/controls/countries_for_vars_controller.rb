module Controls
  class CountriesForVarsController < BaseController
    include DynamicScaffold::Controller
    dynamic_scaffold Country do |c|
      c.list.sorter sequence: :desc

      c.vars :request_time do
        Time.zone.now
      end

      c.vars :controller_name do
        params['controller']
      end

      c.list.item(:id, style: 'width: 80px;')
      c.list.item(:name, style: 'width: 220px;')
      c.list.item(:updated_at, style: 'width: 162px;') do |rec, name|
        rec.fdate(name, '%Y-%m-%d %H:%M:%S')
      end
      c.list.item(:created_at, style: 'width: 162px;') do |rec, name|
        rec.fdate(name, '%Y-%m-%d %H:%M:%S')
      end
      c.list.item('To state', style: 'width: 240px;') do |rec, _name|
        content_tag :a, "To state of #{rec.name}", href: 'foobar'
      end

      c.form.item(:hidden_field, :id)
      c.form.item(:text_field, :name).note do
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
