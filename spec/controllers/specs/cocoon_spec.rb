require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'cocoon' do
    it 'should create items specified.' do
      controller.class.send(:dynamic_scaffold, Shop) do |c|
        c.form.item :cocoon, :shop_memos do |form|
          form.item(:text_field, :title)
          form.item(:text_area, :body)
        end
      end

      get :new, params: { locale: :en }

      cocoon = dynamic_scaffold.form.items.find {|e| e.type? :cocoon }

      expect(cocoon.form.items.length).to eq 2
      expect(cocoon.form.items[0].type?(:text_field)).to be true
      expect(cocoon.form.items[0].name).to eq :title
      expect(cocoon.form.items[1].type?(:text_area)).to be true
      expect(cocoon.form.items[1].name).to eq :body
    end

    it 'should create shop memos on post.' do
      controller.class.send(:dynamic_scaffold, Shop) do |c|
        c.form.item(:text_field, :name).label 'Shop Name'
        c.form.item(:text_field, :category_id)
        c.form.item(:text_field, :status)
        c.form.item :cocoon, :shop_memos do |form|
          form.item(:hidden_field, :id)
          form.item(:text_field, :title)
          form.item(:text_area, :body)
        end
      end
      category = FactoryBot.create(:category)
      expect do
        post :create, params: { locale: :en, shop: {
          name: 'foobar',
          category_id: category.id,
          status: Shop.statuses.keys.first,
          shop_memos_attributes: {
            '1551409107999': {
              _destroy: false,
              title: 'hoge',
              body: 'fuga'
            },
            '1551409108000': {
              _destroy: false,
              title: 'foo',
              body: 'bar'
            }
          }
        } }
      end.to change(ShopMemo, :count).by(2)
      shop = assigns(:record)
      shop_memos = shop.shop_memos.order(:id)

      expect(shop_memos.first.title).to eq 'hoge'
      expect(shop_memos.first.body).to eq 'fuga'

      expect(shop_memos.last.title).to eq 'foo'
      expect(shop_memos.last.body).to eq 'bar'

      patch :update, params: { id: shop.id, locale: :en, shop: {
        name: 'foobar',
        category_id: category.id,
        status: Shop.statuses.keys.first,
        shop_memos_attributes: {
          '0': {
            _destroy: 'false',
            id: shop_memos.first.id,
            title: 'hoge_update',
            body: 'fuga_update'
          },
          '1': {
            _destroy: '1',
            id: shop_memos.last.id,
            title: 'foo',
            body: 'bar'
          }
        }
      } }

      shop = assigns(:record)
      shop_memos = shop.shop_memos.order(:id)

      expect(shop_memos.length).to eq 1
      expect(shop_memos.first.title).to eq 'hoge_update'
      expect(shop_memos.first.body).to eq 'fuga_update'
    end
  end
end
