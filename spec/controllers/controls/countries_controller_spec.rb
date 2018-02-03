require 'rails_helper'
RSpec.describe Controls::CountriesController, type: :controller do
  describe 'Sort' do
    it 'should be able to generate sequence number.' do
      get :index, params: { locale: :en }
      original_sorter = controller.dynamic_scaffold.list.sorter

      controller.dynamic_scaffold.list.sorter(sequence: :desc)
      controller.send(:reset_sequence, (1..5).to_a.size)
      expect(controller.send(:next_sequence!)).to eq 4
      expect(controller.send(:next_sequence!)).to eq 3
      expect(controller.send(:next_sequence!)).to eq 2
      expect(controller.send(:next_sequence!)).to eq 1
      expect(controller.send(:next_sequence!)).to eq 0

      controller.dynamic_scaffold.list.sorter(sequence: :asc)
      controller.send(:reset_sequence, (1..5).to_a.size)
      expect(controller.send(:next_sequence!)).to eq 0
      expect(controller.send(:next_sequence!)).to eq 1
      expect(controller.send(:next_sequence!)).to eq 2
      expect(controller.send(:next_sequence!)).to eq 3
      expect(controller.send(:next_sequence!)).to eq 4

      controller.dynamic_scaffold.list.sorter(original_sorter)
    end
    it 'should be able to sort.' do
      FactoryBot.create_list(:country, 3)
      countries = Country.all.order sequence: :desc

      expect(countries[0].name).to eq 'Country 3'
      expect(countries[1].name).to eq 'Country 2'
      expect(countries[2].name).to eq 'Country 1'

      pkeys = []
      pkeys << { id: countries[1].id }
      pkeys << { id: countries[0].id }
      pkeys << { id: countries[2].id }
      patch :sort, params: { locale: :en, pkeys: pkeys, submit_sort: '' }
      countries = Country.all.order sequence: :desc
      expect(countries[0].name).to eq 'Country 2'
      expect(countries[1].name).to eq 'Country 3'
      expect(countries[2].name).to eq 'Country 1'
      expect(response).to redirect_to controls_master_countries_path

      pkeys = []
      pkeys << { id: countries[0].id }
      pkeys << { id: countries[2].id }
      pkeys << { id: countries[1].id }
      patch :sort, params: { locale: 'ja', pkeys: pkeys, submit_sort: '' }
      countries = Country.all.order sequence: :desc
      expect(countries[0].name).to eq 'Country 2'
      expect(countries[1].name).to eq 'Country 1'
      expect(countries[2].name).to eq 'Country 3'
      expect(response).to redirect_to controls_master_countries_path
    end
  end

  describe 'Delete' do
    it 'should be able to delete.' do
      country = FactoryBot.create(:country)
      delete :destroy, params: { locale: :en, id: country.id }

      expect(Country.find_by(id: country.id)).to be_nil
      expect(response).to redirect_to controls_master_countries_path
    end
    it 'should display error if you delete record that can not be deleted with foreign key constraints' do
      state = FactoryBot.create(:state)
      delete :destroy, params: {
        locale: :en,
        id: state.country.id
      }

      expect(Country.find_by(id: state.country.id)).not_to be_nil
      expect(flash['dynamic_scaffold_danger']).not_to be_nil
      expect(response).to redirect_to controls_master_countries_path
    end
  end

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
