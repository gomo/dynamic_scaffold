require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'globalize_fields' do
    render_views
    it 'should display additional elements on the page.' do
      controller.class.send(:dynamic_scaffold, Shop) do |c|
        locales = { en: 'English', ja: '日本語' }
        c.form.item(:text_field, :name)
        c.form.item(:text_field, :category_id)
        c.form.item(:text_field, :status)
        c.form.item(:globalize_fields, locales).for(:text_field, :keyword)
        c.form.item(:globalize_fields, locales).for(:text_area, :desc)
      end

      get :new, params: { locale: :en }

      doc = Nokogiri::HTML(response.body)
      expect(doc.css('input[type="text"][name="shop[translations_attributes][1][keyword]"]').length).to eq 1
      expect(doc.css('input[type="hidden"][name="shop[translations_attributes][1][id]"]').length).to eq 1
      expect(doc.css('input[type="hidden"][name="shop[translations_attributes][1][locale]"]').length).to eq 1

      expect(doc.css('input[type="text"][name="shop[translations_attributes][2][keyword]"]').length).to eq 1
      expect(doc.css('input[type="hidden"][name="shop[translations_attributes][2][id]"]').length).to eq 1
      expect(doc.css('input[type="hidden"][name="shop[translations_attributes][2][locale]"]').length).to eq 1

      expect(doc.css('textarea[name="shop[translations_attributes][1][desc]"]').length).to eq 1
      expect(doc.css('textarea[name="shop[translations_attributes][2][desc]"]').length).to eq 1

      category = FactoryBot.create(:category)
      expect do
        post :create, params: { locale: :en, shop: {
          name: 'foobar',
          category_id: category.id,
          status: Shop.statuses.keys.first,
          translations_attributes: {
            1 => {
              id: '',
              locale: :en,
              keyword: 'English keyword',
              desc: 'English description'
            },
            2 => {
              id: '',
              locale: :ja,
              keyword: '日本語　キーワード',
              desc: '日本語 説明'
            }
          }
        } }
      end.to change(Shop, :count).by(1)

      shop = assigns(:record)

      Globalize.with_locale(:en) do
        expect(shop.keyword).to eq 'English keyword'
        expect(shop.desc).to eq 'English description'
      end

      Globalize.with_locale(:ja) do
        expect(shop.keyword).to eq '日本語　キーワード'
        expect(shop.desc).to eq '日本語 説明'
      end
    end
  end
end
