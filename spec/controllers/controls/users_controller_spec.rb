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
end
