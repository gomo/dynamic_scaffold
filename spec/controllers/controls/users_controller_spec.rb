require 'rails_helper'

RSpec.describe Controls::UsersController, type: :controller do
  describe 'Index' do
    render_views
    it 'should only see the users for the specified role.' do
      FactoryBot.create_list(:user, 3, role_value: :admin)
      FactoryBot.create_list(:user, 3, role_value: :staff)
      FactoryBot.create_list(:user, 3, role_value: :member)

      get :index, params: { locale: :en, role: 'admin' }
      expect(response.body).to match(/<div class="resplist-value">admin<\/div>/)
      expect(response.body).not_to match(/<div class="resplist-value">staff<\/div>/)
      expect(response.body).not_to match(/<div class="resplist-value">member<\/div>/)

      get :index, params: { locale: :en, role: 'staff' }
      expect(response.body).not_to match(/<div class="resplist-value">admin<\/div>/)
      expect(response.body).to match(/<div class="resplist-value">staff<\/div>/)
      expect(response.body).not_to match(/<div class="resplist-value">member<\/div>/)

      get :index, params: { locale: :en, role: 'member' }
      expect(response.body).not_to match(/<div class="resplist-value">admin<\/div>/)
      expect(response.body).not_to match(/<div class="resplist-value">staff<\/div>/)
      expect(response.body).to match(/<div class="resplist-value">member<\/div>/)
    end
  end
  describe 'New' do
    render_views
    it 'should bind the specified value to the role field.' do
      get :new, params: { locale: :en, role: 'admin' }
      # Check whether non scpope column is hidden.
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
      admin = FactoryBot.create(:user, role_value: :admin)
      staff = FactoryBot.create(:user, role_value: :staff)
      member = FactoryBot.create(:user, role_value: :member)
      expect do
        get :edit, params: { locale: :en, role: 'admin', key: admin.primary_key_value }
      end.not_to raise_error
      expect do
        get :edit, params: { locale: :en, role: 'admin', key: staff.primary_key_value }
      end.to raise_error(::ActiveRecord::RecordNotFound)
      expect do
        get :edit, params: { locale: :en, role: 'admin', key: member.primary_key_value }
      end.to raise_error(::ActiveRecord::RecordNotFound)
    end
  end

  describe 'Update' do
    it 'should not let edit user who is not the specified roles.' do
      admin = FactoryBot.create(:user, role_value: :admin)
      staff = FactoryBot.create(:user, role_value: :staff)
      member = FactoryBot.create(:user, role_value: :member)
      expect do
        patch :update, params: { locale: :en, role: 'admin', user: {
          id: admin.id,
          email: 'udpate@example.com'
        } }
      end.not_to raise_error
      expect do
        patch :update, params: { locale: :en, role: 'admin', user: {
          id: staff.id,
          email: 'udpate@example.com'
        } }
      end.to raise_error(::ActiveRecord::RecordNotFound)
      expect do
        patch :update, params: { locale: :en, role: 'admin', user: {
          id: member.id,
          email: 'udpate@example.com'
        } }
      end.to raise_error(::ActiveRecord::RecordNotFound)
    end
    it 'should raise the exception if update with an unspecified role.' do
      admin = FactoryBot.create(:user, role_value: :admin)

      expect do
        patch :update, params: { locale: :en, role: 'admin', user: {
          id: admin.id,
          email: 'udpate@example.com',
          role: :staff
        } }
      end.to raise_error(DynamicScaffold::Error::InvalidParameter)
    end
  end

  describe 'Sort' do
    it 'should raise an exception if there is even one record other than the specified scope.' do
      staffs = FactoryBot.create_list(:user, 3, role_value: :staff)

      pkeys = []
      pkeys << { id: staffs[1].id }
      pkeys << { id: staffs[0].id }
      pkeys << { id: staffs[2].id }
      expect do
        patch :sort_or_destroy, params: { locale: :en, role: :admin, pkeys: pkeys, submit_sort: '' }
      end.to raise_error(::ActiveRecord::RecordNotFound)
    end
  end

  describe 'Delete' do
    it 'should not let destory user who is not the specified roles.' do
      staff = FactoryBot.create(:user, role_value: :staff)

      expect do
        patch :sort_or_destroy, params: { locale: :en, role: :admin, submit_destroy: staff.primary_key_value.to_json }
      end.to raise_error(::ActiveRecord::RecordNotFound)
    end
  end

  describe '#dynamic_scaffold_path' do
    it 'should be able to get path.' do
      get :index, params: { locale: :en, role: 'admin' }

      expect(controller.dynamic_scaffold_path(:index)).to eq '/en/controls/master/users/admin'
      expect(controller.dynamic_scaffold_path(:new)).to eq '/en/controls/master/users/admin/new'
      expect(controller.dynamic_scaffold_path(:sort_or_destroy)).to eq '/en/controls/master/users/admin/sort_or_destroy'
      expect(controller.dynamic_scaffold_path(:update)).to eq '/en/controls/master/users/admin/update'
    end
  end
end
