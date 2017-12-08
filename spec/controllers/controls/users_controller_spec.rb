require 'rails_helper'

RSpec.describe Controls::UsersController, type: :controller do
  describe 'Index' do
    render_views
    it 'should only see the users for the specified role.' do
      admins = FactoryBot.create_list(:user, 3, role_value: :admin)
      staffs = FactoryBot.create_list(:user, 3, role_value: :staff)
      members = FactoryBot.create_list(:user, 3, role_value: :member)
      
      get :index, params: { locale: :en, role: "admin" }
      expect(response.body).to match /<div class="resplist-value">admin<\/div>/
      expect(response.body).not_to match /<div class="resplist-value">staff<\/div>/
      expect(response.body).not_to match /<div class="resplist-value">member<\/div>/

      get :index, params: { locale: :en, role: "staff" }
      expect(response.body).not_to match /<div class="resplist-value">admin<\/div>/
      expect(response.body).to match /<div class="resplist-value">staff<\/div>/
      expect(response.body).not_to match /<div class="resplist-value">member<\/div>/

      get :index, params: { locale: :en, role: "member" }
      expect(response.body).not_to match /<div class="resplist-value">admin<\/div>/
      expect(response.body).not_to match /<div class="resplist-value">staff<\/div>/
      expect(response.body).to match /<div class="resplist-value">member<\/div>/
    end
  end
  describe 'New' do
    render_views
    it 'should bind the specified value to the role field.' do      
      get :new, params: { locale: :en, role: "admin" }
      # Check whether non scpope column is hidden.
      expect(response.body).to match /<input class="form-control" type="text" name="user\[email\]" \/>/
      expect(response.body).to match /<input type="hidden" value="admin" name="user\[role\]" \/>/

      get :new, params: { locale: :en, role: "staff" }
      expect(response.body).to match /<input type="hidden" value="staff" name="user\[role\]" \/>/

      get :new, params: { locale: :en, role: "member" }
      expect(response.body).to match /<input type="hidden" value="member" name="user\[role\]" \/>/
    end
  end

  describe 'Edit' do
    render_views
    it 'should not let edit user who is not the specified roles.' do
      get :index, params: { locale: :en, role: "admin" }
      util = assigns(:dynamic_scaffold_util)

      admin = FactoryBot.create(:user, role_value: :admin)
      staff = FactoryBot.create(:user, role_value: :staff)
      member = FactoryBot.create(:user, role_value: :member)
      expect {
        get :edit, params: { locale: :en, role: "admin", key: util.pkey_params(admin) }
      }.not_to raise_error
      expect {
        get :edit, params: { locale: :en, role: "admin", key: util.pkey_params(staff) }
      }.to raise_error(ActiveRecord::RecordNotFound)
      expect {
        get :edit, params: { locale: :en, role: "admin", key: util.pkey_params(member) }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'Update' do
    render_views
    it 'should not let edit user who is not the specified roles.' do
      get :index, params: { locale: :en, role: "admin" }
      util = assigns(:dynamic_scaffold_util)

      admin = FactoryBot.create(:user, role_value: :admin)
      staff = FactoryBot.create(:user, role_value: :staff)
      member = FactoryBot.create(:user, role_value: :member)
      expect {
        patch :update, params: { locale: :en, role: "admin", user: {
          id: admin.id,
          email: 'udpate@example.com'
        }}
      }.not_to raise_error
      expect {
        patch :update, params: { locale: :en, role: "admin", user: {
          id: staff.id,
          email: 'udpate@example.com'
        }}
      }.to raise_error(ActiveRecord::RecordNotFound)
      expect {
        patch :update, params: { locale: :en, role: "admin", user: {
          id: member.id,
          email: 'udpate@example.com'
        }}
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
    it 'should raise the exception if update with an unspecified role.' do
      get :index, params: { locale: :en, role: "admin" }
      util = assigns(:dynamic_scaffold_util)

      admin = FactoryBot.create(:user, role_value: :admin)
      
      expect {
        patch :update, params: { locale: :en, role: "admin", user: {
          id: admin.id,
          email: 'udpate@example.com',
          role: :staff
        }}
      }.to raise_error(DynamicScaffold::Error::InvalidParameter)
    end
  end

  describe 'Sort' do
    it 'should raise an exception if there is even one record other than the specified scope.' do
      get :index, params: { locale: :en, role: :admin }
      util = assigns(:dynamic_scaffold_util)

      staffs = FactoryBot.create_list(:user, 3, role_value: :staff)

      pkeys = []
      pkeys << util.pkey_string(staffs[1])
      pkeys << util.pkey_string(staffs[0])
      pkeys << util.pkey_string(staffs[2])
      expect {
        patch :sort_or_destroy, params: { locale: :en, role: :admin, pkeys: pkeys, submit_sort: '' }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'Delete' do
    it 'should not let destory user who is not the specified roles.' do
      get :index, params: { locale: :en, role: :admin }
      util = assigns(:dynamic_scaffold_util)

      staff = FactoryBot.create(:user, role_value: :staff)

      expect {
        patch :sort_or_destroy, params: { locale: :en, role: :admin, submit_destroy: util.pkey_string(staff) }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#path_for' do
    it 'should be able to get path.' do
      get :index, params: { locale: :en, role: "admin" }
      util = assigns(:dynamic_scaffold_util)

      expect(util.path_for(:index)).to eq '/en/controls/master/users/admin'
      expect(util.path_for(:new)).to eq '/en/controls/master/users/admin/new'
      expect(util.path_for(:sort_or_destroy)).to eq '/en/controls/master/users/admin/sort_or_destroy'
      expect(util.path_for(:update)).to eq '/en/controls/master/users/admin/update'
    end
  end
end
