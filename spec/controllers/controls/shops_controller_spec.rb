require 'rails_helper'

RSpec.describe Controls::ShopsController, type: :controller do
  describe 'Create' do
    render_views
    it 'should be able to create.' do
      get :new, params: { locale: :en }
      expect(response).to render_template(:new)
      expect(response.body).not_to match(/class="[^"]*dynamicScaffold\-error\-message[^"]*"/)

      # fail
      post :create, params: { locale: :en, shop: { name: '' } }
      expect(response).to render_template(:new)
      expect(response).not_to redirect_to controls_master_shops_path
      expect(response.body).to match(/class="[^"]*dynamicScaffold\-error\-message[^"]*"/)

      # success
      category = FactoryBot.create(:category)
      states = FactoryBot.create_list(:state, 3)
      post :create, params: { locale: :en, shop: {
        name: 'foobar',
        memo: 'memo memo memo',
        category_id: category.id,
        state_ids: states.pluck(:id),
        status: Shop.statuses.keys.first
      } }
      shop = assigns(:record)
      shop.reload
      expect(shop.name).to eq 'foobar'
      expect(shop.memo).to eq 'memo memo memo'
      expect(shop.category_id).to eq category.id
      expect(shop.states.pluck(:id)).to match_array states.pluck(:id)
      expect(shop.status).to eq Shop.statuses.keys.first

      expect(response).to redirect_to controls_master_shops_path
    end
  end
  describe 'Edit' do
    render_views
    it 'should be able to edit.' do
      shop = FactoryBot.create(:shop)
      get :edit, params: { locale: :en, key: shop.primary_key_value }
      expect(response).to render_template(:edit)
      expect(response.body).not_to match(/class="[^"]*dynamicScaffold\-error\-message[^"]*"/)

      # fail
      patch :update, params: { locale: :en, shop: {
        id: shop.id,
        name: ''
      } }
      expect(response).to render_template(:edit)
      expect(response).not_to redirect_to controls_master_shops_path
      expect(response.body).to match(/class="[^"]*dynamicScaffold\-error\-message[^"]*"/)

      category = FactoryBot.create(:category)
      states = FactoryBot.create_list(:state, 2)
      patch :update, params: { locale: :en, shop: {
        id: shop.id,
        name: 'udpate',
        memo: 'udpate udpate udpate',
        category_id: category.id,
        state_ids: states.pluck(:id),
        status: Shop.statuses.keys.second
      } }

      # success
      updated_shop = assigns(:record)
      updated_shop.reload
      expect(updated_shop.name).to eq 'udpate'
      expect(updated_shop.memo).to eq 'udpate udpate udpate'
      expect(updated_shop.category_id).to eq category.id
      expect(updated_shop.states.pluck(:id)).to match_array states.pluck(:id)
      expect(updated_shop.status).to eq Shop.statuses.keys.second

      expect(response).to redirect_to controls_master_shops_path
    end
  end
  describe '#dynamic_scaffold_path' do
    it 'should be able to get path.' do
      get :index, params: { locale: :en }

      expect(controller.dynamic_scaffold_path(:index)).to eq '/en/controls/master/shops'
      expect(controller.dynamic_scaffold_path(:new)).to eq '/en/controls/master/shops/new'
      expect(controller.dynamic_scaffold_path(:sort_or_destroy)).to eq '/en/controls/master/shops/sort_or_destroy'
      expect(controller.dynamic_scaffold_path(:update)).to eq '/en/controls/master/shops/update'
    end
  end
end
