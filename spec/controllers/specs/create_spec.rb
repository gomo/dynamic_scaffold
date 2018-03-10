require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'Create' do
    it 'should success request new action' do
      controller.class.send(:dynamic_scaffold, Shop) {}

      get :new, params: { locale: :en }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
    end

    it 'should fail on without name value.' do
      controller.class.send(:dynamic_scaffold, Shop) {}

      expect do
        post :create, params: { locale: :en, shop: { name: '' } }
      end.to change(Shop, :count).by(0)

      expect(assigns(:record).errors[:name].length).to eq 2
      expect(response).to render_template(:new)
      expect(response).not_to redirect_to specs_path
    end

    it 'should success' do
      controller.class.send(:dynamic_scaffold, Shop) do |c|
        c.form.item(:text_field, :id)
        c.form.item(:text_field, :name).label 'Shop Name'
        c.form.item(:text_field, :memo)
        c.form.item(:text_field, :category_id)
        c.form.item(:collection_check_boxes, :state_ids, State.all, :id, :name)
        c.form.item(:text_field, :status)
      end

      category = FactoryBot.create(:category)
      states = FactoryBot.create_list(:state, 3)

      expect do
        post :create, params: { locale: :en, shop: {
          name: 'foobar',
          memo: 'memo memo memo',
          category_id: category.id,
          state_ids: states.pluck(:id),
          status: Shop.statuses.keys.first
        } }
      end.to change(Shop, :count).by(1)
      shop = assigns(:record)
      shop.reload
      expect(shop.name).to eq 'foobar'
      expect(shop.memo).to eq 'memo memo memo'
      expect(shop.category_id).to eq category.id
      expect(shop.states.pluck(:id)).to match_array states.pluck(:id)
      expect(shop.status).to eq Shop.statuses.keys.first

      expect(response).to redirect_to specs_path
    end
  end
end
