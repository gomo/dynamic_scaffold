require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  
  describe 'Insert After' do
    render_views
    it 'should insert a tag after the specified element.' do
      controller.class.send(:dynamic_scaffold, Country) do |c|
        c.form.item(:text_field, :id).insert(:after) do |rec|
          tag.div 'foobar'
        end
      end

      get :new, params: { locale: :en }

      expect(response.body).to match(
        /<input class="form-control" type="text" name="country\[id\]" \/>[\s\S]*?<div>foobar<\/div>/
      )
    end
  end

  describe 'Insert Before' do
    render_views
    it 'should insert a tag before the specified element.' do
      controller.class.send(:dynamic_scaffold, Country) do |c|
        c.form.item(:text_field, :id).insert(:before) do |rec|
          tag.div 'foobar'
        end
      end

      get :new, params: { locale: :en }

      expect(response.body).to match(
        /<div>foobar<\/div>[\s\S]*?<input class="form-control" type="text" name="country\[id\]" \/>/
      )
    end
  end

  describe 'form.permit_params' do
    it 'should be able to add permit parameters.' do
      controller.class.send(:dynamic_scaffold, Shop) do |c|
        c.form.permit_params(:foobar)
      end

      post :create, params: { locale: :en, shop: {foobar: 'foobar'}}
      record = assigns(:record)
      expect(record.foobar).to eq 'foobar'
    end
  end
end
