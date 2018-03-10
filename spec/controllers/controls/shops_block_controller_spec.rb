require 'rails_helper'

RSpec.describe Controls::ShopsBlockController, type: :controller do
  describe 'Create' do
    render_views
  end
  describe 'Edit' do
    render_views
    it 'should be able to edit.' do
      shop = FactoryBot.create(:shop)
      get :edit, params: { locale: :en, id: shop.id }
      expect(response).to render_template(:edit)
      expect(response.body).not_to match(/class="[^"]*dynamicScaffold\-error\-message[^"]*"/)

      # fail
      patch :update, params: { locale: :en, id: shop.id, shop: {
        id: shop.id,
        name: ''
      } }
      expect(response).to render_template(:edit)
      expect(response).not_to redirect_to edit_controls_master_shops_block_path
      expect(response.body).to match(/class="[^"]*dynamicScaffold\-error\-message[^"]*"/)

      category = FactoryBot.create(:category)
      states = FactoryBot.create_list(:state, 2)
      patch :update, params: { locale: :en, id: shop.id, shop: {
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

      expect(response).to redirect_to controls_master_shops_block_index_path
    end
  end
  describe 'block' do
    render_views
    it 'should display additional elements on the page.' do
      get :new, params: { locale: :en }
      body = response.body.delete!("\n").gsub!(/> +</, '><')
      expect(body).to match(/<label>Block<\/label>/)
      expect(body).to match(/<div><input class="form-control" type="text" name="shop\[block\]" \/><\/div>/)
      expect(body).to match(/<label>Block with label<\/label>/)
      expect(body).to match(/<input class="form-control" type="text" name="shop\[block_with_label\]" \/>/)
    end
  end
end
