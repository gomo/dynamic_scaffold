require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  let :shop do
    FactoryBot.create(:shop)
  end
  describe 'Update' do
    it 'should success request edit action' do
      controller.class.send(:dynamic_scaffold, Shop) {}

      get :edit, params: { locale: :en, id: shop.id }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
    end

    it 'should fail on without name value.' do
      controller.class.send(:dynamic_scaffold, Shop) {}

      patch :update, params: { locale: :en, id: shop.id, shop: {
        id: shop.id,
        name: ''
      } }

      expect(assigns(:record).errors[:name].length).to eq 2
      expect(response).to render_template(:edit)
      expect(response).not_to redirect_to specs_path
    end

    it 'should success' do
      controller.class.send(:dynamic_scaffold, Shop) do |c|
        c.form.item(:text_field, :name).label 'Shop Name'
        c.form.item(:text_field, :memo)
        c.form.item(:text_field, :category_id)
        c.form.item(:collection_check_boxes, :state_ids, State.all, :id, :name)
        c.form.item(:text_field, :status)
      end

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

      updated_shop = assigns(:record)
      updated_shop.reload
      expect(updated_shop.name).to eq 'udpate'
      expect(updated_shop.memo).to eq 'udpate udpate udpate'
      expect(updated_shop.category_id).to eq category.id
      expect(updated_shop.states.pluck(:id)).to match_array states.pluck(:id)
      expect(updated_shop.status).to eq Shop.statuses.keys.second

      expect(response).to redirect_to specs_path
    end
  end
end
