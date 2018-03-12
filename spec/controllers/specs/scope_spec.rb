require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'Scope' do
    describe 'Index' do
      it 'should only see the users for the specified role.' do
        controller.class.send(:dynamic_scaffold, User) do |c|
          c.scope [:role]
        end
        FactoryBot.create_list(:user, 3, role_value: :admin)
        FactoryBot.create_list(:user, 3, role_value: :staff)
        FactoryBot.create_list(:user, 3, role_value: :member)

        get :index, params: { locale: :en, role: 'admin' }
        records = assigns(:records)
        expect(records.length).to eq 3
        expect(records.map(&:role)).to all(eq 'admin')

        get :index, params: { locale: :en, role: 'staff' }
        records = assigns(:records)
        expect(records.length).to eq 3
        expect(records.map(&:role)).to all(eq 'staff')

        get :index, params: { locale: :en, role: 'member' }
        records = assigns(:records)
        expect(records.length).to eq 3
        expect(records.map(&:role)).to all(eq 'member')
      end
    end

    describe 'New' do
      render_views
      it 'should bind the specified value to the role field.' do
        controller.class.send(:dynamic_scaffold, User) do |c|
          c.scope [:role]
        end

        get :new, params: { locale: :en, role: 'admin' }
        # Check whether scope column is hidden.
        expect(response.body).to match(/<input class="form-control" type="text" name="user\[email\]" \/>/)
        expect(response.body).to match(/<input type="hidden" value="admin" name="user\[role\]" \/>/)

        get :new, params: { locale: :en, role: 'staff' }
        expect(response.body).to match(/<input type="hidden" value="staff" name="user\[role\]" \/>/)

        get :new, params: { locale: :en, role: 'member' }
        expect(response.body).to match(/<input type="hidden" value="member" name="user\[role\]" \/>/)
      end
    end

    describe 'Edit' do
      it 'should not let edit user who is not the specified roles.' do
        controller.class.send(:dynamic_scaffold, User) do |c|
          c.scope [:role]
        end

        admin = FactoryBot.create(:user, role_value: :admin)
        staff = FactoryBot.create(:user, role_value: :staff)
        member = FactoryBot.create(:user, role_value: :member)
        expect do
          get :edit, params: { locale: :en, role: 'admin', id: admin.id }
        end.not_to raise_error
        expect do
          get :edit, params: { locale: :en, role: 'admin', id: staff.id }
        end.to raise_error(::ActiveRecord::RecordNotFound)
        expect do
          get :edit, params: { locale: :en, role: 'admin', id: member.id }
        end.to raise_error(::ActiveRecord::RecordNotFound)
      end
    end

    describe 'Update' do
      it 'should not let edit user who is not the specified roles.' do
        controller.class.send(:dynamic_scaffold, User) do |c|
          c.scope [:role]
        end

        admin = FactoryBot.create(:user, role_value: :admin)
        staff = FactoryBot.create(:user, role_value: :staff)
        member = FactoryBot.create(:user, role_value: :member)
        expect do
          patch :update, params: { id: admin.id, locale: :en, role: 'admin', user: {
            id: admin.id,
            email: 'udpate@example.com'
          } }
        end.not_to raise_error
        expect do
          patch :update, params: { id: staff.id, locale: :en, role: 'admin', user: {
            id: staff.id,
            email: 'udpate@example.com'
          } }
        end.to raise_error(::ActiveRecord::RecordNotFound)
        expect do
          patch :update, params: { id: member.id, locale: :en, role: 'admin', user: {
            id: member.id,
            email: 'udpate@example.com'
          } }
        end.to raise_error(::ActiveRecord::RecordNotFound)
      end
      it 'should raise the exception if update with an unspecified role.' do
        admin = FactoryBot.create(:user, role_value: :admin)

        expect do
          patch :update, params: { id: admin.id, locale: :en, role: 'admin', user: {
            id: admin.id,
            email: 'udpate@example.com',
            role: :staff
          } }
        end.to raise_error(DynamicScaffold::Error::InvalidParameter)
      end
    end

    describe 'Sort' do
      it 'should raise an exception if there is even one record other than the specified scope.' do
        controller.class.send(:dynamic_scaffold, User) do |c|
          c.scope [:role]
          c.list.sorter sequence: :desc
        end

        staffs = FactoryBot.create_list(:user, 3, role_value: :staff)

        pkeys = []
        pkeys << { id: staffs[1].id }
        pkeys << { id: staffs[0].id }
        pkeys << { id: staffs[2].id }
        expect do
          patch :sort, params: { locale: :en, role: :admin, pkeys: pkeys, submit_sort: '' }
        end.to raise_error(::ActiveRecord::RecordNotFound)
      end
    end

    describe 'Delete' do
      it 'should not let destory user who is not the specified roles.' do
        controller.class.send(:dynamic_scaffold, User) do |c|
          c.scope [:role]
        end

        staff = FactoryBot.create(:user, role_value: :staff)

        expect do
          delete :destroy, params: {
            locale: :en,
            role: :admin,
            id: staff.id
          }
        end.to raise_error(::ActiveRecord::RecordNotFound)
      end
    end
  end
end
