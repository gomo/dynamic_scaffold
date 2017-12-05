require 'rails_helper'

RSpec.describe Controls::ShopController, type: :controller do
  describe 'Create' do
    render_views
    it 'should be able to create.' do
      post :create, params: {locale: :en, trailing_slash: true, shop: {name: ''}}
      expect(response).to render_template(:new)
      expect(response.body).to match /class="[^"]*dynamicScaffold\-error\-message[^"]*"/

      category = FactoryBot.create(:category)
      states = FactoryBot.create_list(:state, 3)
      post :create, params: {locale: :en, trailing_slash: true, shop: {
        name: 'foobar',
        memo: 'memo memo memo',
        category_id: category.id,
        state_ids: states.pluck(:id),
        status: Shop.statuses.keys.first
      }}
      shop = assigns(:record)
      shop.reload
      expect(shop.name).to eq 'foobar'
      expect(shop.memo).to eq 'memo memo memo'
      expect(shop.category_id).to eq category.id
      expect(shop.states.pluck(:id)).to match_array states.pluck(:id)
      expect(shop.status).to eq Shop.statuses.keys.first

      expect(response).to redirect_to controls_master_shop_path
    end
  end
  describe 'Path Util' do
    it 'should be able to get path.' do
      get :index, params: { locale: :en, trailing_slash: true }
      util = assigns(:dynamic_scaffold_util)

      expect(util.path_for(:index)).to eq '/en/controls/master/shop/'
      expect(util.path_for(:new)).to eq '/en/controls/master/shop/new'
      expect(util.path_for(:sort)).to eq '/en/controls/master/shop/sort'
    end
  end
end
