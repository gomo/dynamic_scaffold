require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'Filter' do
    render_views
    it 'should be able to filter the list items.' do
      controller.class.send(:dynamic_scaffold, Country) do |c|
        c.list.filter do |query|
          query.where(name: 'foo')
        end
        c.list.item(:name, style: 'width: 120px;')
        c.form.item(:text_field, :name)
        c.form.item(:text_field, :sequence)
      end

      FactoryBot.create(:country, with_name: 'foo')
      FactoryBot.create(:country, with_name: 'bar')
      get :index, params: { locale: :en }
      doc = Nokogiri::HTML(response.body)
      expect(doc.css('.js-ds-list-row').length).to eq 1
    end

    it 'should also affect max_count.' do
      controller.class.send(:dynamic_scaffold, Country) do |c|
        c.max_count = 1
        c.list.filter do |query|
          query.where(name: 'foo')
        end
        c.list.item(:name, style: 'width: 120px;')
        c.form.item(:text_field, :name)
        c.form.item(:text_field, :sequence)
      end

      expect do
        post :create, params: { locale: :en, country: {
          name: 'hoge',
          sequence: 1
        } }
      end.to change(Country, :count).by(1)

      expect do
        post :create, params: { locale: :en, country: {
          name: 'huga',
          sequence: 1
        } }
      end.to change(Country, :count).by(1)
    end
  end
end
