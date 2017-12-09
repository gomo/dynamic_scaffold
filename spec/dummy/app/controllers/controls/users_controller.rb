module Controls
  class UsersController < BaseController
    include DynamicScaffold::Controller
    dynamic_scaffold User do |c|
      c.scope [:role]

      c.list.sorter sequence: :desc

      c.list.item(:id, style: 'width: 80px')
      c.list.item(:role, style: 'width: 80px')
      c.list.item(:email, style: 'width: 190px')
      c.list.item :updated_at, style: 'width: 180px' do |rec, name|
        rec.fdate name, '%Y-%m-%d %H:%M:%S'
      end
      c.list.item(:created_at, style: 'width: 180px').label 'Create Date' do |rec, name|
        rec.fdate name, '%Y-%m-%d %H:%M:%S'
      end
    end
  end
end
