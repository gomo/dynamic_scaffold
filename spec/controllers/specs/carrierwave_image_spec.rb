require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'carrierwave_image' do
    render_views
    it 'should display additional elements on the page.' do
      controller.class.send(:dynamic_scaffold, Shop) do |c|
        c.form.item :carrierwave_image, :image
      end
      get :new, params: { locale: :en }
      doc = Nokogiri::HTML(response.body)

      # wrapper
      wrappers = doc.css('.js-ds-image-wrapper')
      expect(wrappers.length).to eq 1
      wrapper = wrappers.first

      # preview
      expect(wrapper.css('.js-ds-image-preview').length).to eq 1

      # file input
      expect(wrapper.css('.js-ds-image').length).to eq 1
      file = wrapper.css('.js-ds-image').first
      expect(file.name).to eq 'input'
      expect(file.attribute('type').value).to eq 'file'

      # remove_flag
      expect(wrapper.css('.js-ds-image-remove-flag').length).to eq 1
      flag = wrapper.css('.js-ds-image-remove-flag').first
      expect(flag.name).to eq 'input'
      expect(flag.attribute('type').value).to eq 'hidden'
      expect(flag.attribute('value').value).to eq '1'
    end

    it 'should be able to upload images.' do
      controller.class.send(:dynamic_scaffold, Shop) do |c|
        c.form.item(:carrierwave_image, :image)
        c.form.item(:text_field, :name)
        c.form.item(:text_field, :memo)
        c.form.item(:text_field, :category_id)
        c.form.item(:text_field, :status)
      end

      category = FactoryBot.create(:category)

      expect do
        image = Rack::Test::UploadedFile.new(
          Rails.root.join('..', '..', 'spec', 'fixtures', 'images', '150x150.png')
        )
        post :create, params: { locale: :en, shop: {
          image: image,
          name: 'foobar',
          category_id: category.id,
          status: Shop.statuses.keys.first
        } }
      end.to change(Shop, :count).by(1)
      shop = assigns(:record)
      expect(shop.image.file).not_to be nil

      # removable
      patch :update, params: { locale: :en, id: shop.id, shop: {
        id: shop.id,
        remove_image: '1'
      } }
      shop = assigns(:record)
      expect(shop.image.file).to be nil
    end

    it 'should be able to dispable remove.' do
      controller.class.send(:dynamic_scaffold, Shop) do |c|
        c.form.item :carrierwave_image, :image, removable: false
        c.form.item(:text_field, :name)
        c.form.item(:text_field, :memo)
        c.form.item(:text_field, :category_id)
        c.form.item(:text_field, :status)
      end
      get :new, params: { locale: :en }
      doc = Nokogiri::HTML(response.body)

      wrapper = doc.css('.js-ds-image-wrapper').first
      # remove_flag
      expect(wrapper.css('.js-ds-image-remove').length).to eq 0
      expect(wrapper.css('.js-ds-image-remove-flag').length).to eq 0

      shop = FactoryBot.create(:shop)
      shop.image = Rails.root.join('..', '..', 'spec', 'fixtures', 'images', '150x150.png').open
      shop.save!

      patch :update, params: { locale: :en, id: shop.id, shop: {
        id: shop.id,
        remove_image: '1'
      } }
      shop = assigns(:record)
      expect(shop.image.file).not_to be nil
    end
  end
end
