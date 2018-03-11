require 'rails_helper'
RSpec.describe Controls::CountriesController, type: :controller do
  describe '#dynamic_scaffold_path' do
    it 'should be able to get path.' do
      get :index, params: { locale: :en }
      expect(controller.send(:dynamic_scaffold_path, :index)).to eq '/en/controls/master/countries'
      expect(controller.send(:dynamic_scaffold_path, :new)).to eq '/en/controls/master/countries/new'
      expect(controller.send(:dynamic_scaffold_path, :edit, id: 1)).to eq '/en/controls/master/countries/1/edit'
      expect(controller.send(:dynamic_scaffold_path, :update, id: 1)).to eq '/en/controls/master/countries/1'
      expect(controller.send(:dynamic_scaffold_path, :sort)).to eq '/en/controls/master/countries/sort'
    end
  end

  describe 'No Pagination' do
    render_views
    it 'should display all items.' do
      FactoryBot.create_list(:country, 8)
      get :index, params: { locale: :en }
      expect(response.body.scan(/<li class="resplist-row dynamicScaffoldJs-item-row">/).size).to eq 8
      expect(response.body).not_to match(/<ul class="pagination/)
    end
  end

  describe 'Create with sorter' do
    it 'should set max value for sorter column.' do
      post :create, params: { locale: :en, country: {
        name: 'foobar'
      } }
      country = assigns(:record)
      expect(country.sequence).to eq 0

      post :create, params: { locale: :en, country: {
        name: 'foobar'
      } }
      country = assigns(:record)
      expect(country.sequence).to eq 1
    end
  end
end
