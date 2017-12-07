require 'rails_helper'
RSpec.describe Controls::CountriesController, type: :controller do
  describe 'Sort' do
    it 'should be able to sort.' do
      get :index, params: { locale: :en }
      util = assigns(:dynamic_scaffold_util)

      FactoryBot.create_list(:country, 3)
      countries = Country.all.order sequence: :desc

      expect(countries[0].name).to eq 'Country 3'
      expect(countries[1].name).to eq 'Country 2'
      expect(countries[2].name).to eq 'Country 1'

      pkeys = []
      pkeys << util.pkey_string(countries[1])
      pkeys << util.pkey_string(countries[0])
      pkeys << util.pkey_string(countries[2])
      patch :sort_or_destroy, params: { locale: :en, pkeys: pkeys, submit_sort: '' }
      countries = Country.all.order sequence: :desc
      expect(countries[0].name).to eq 'Country 2'
      expect(countries[1].name).to eq 'Country 3'
      expect(countries[2].name).to eq 'Country 1'
      expect(response).to redirect_to controls_master_countries_path

      pkeys = []
      pkeys << util.pkey_string(countries[0])
      pkeys << util.pkey_string(countries[2])
      pkeys << util.pkey_string(countries[1])
      patch :sort_or_destroy, params: { locale: 'ja', pkeys: pkeys, submit_sort: '' }
      countries = Country.all.order sequence: :desc
      expect(countries[0].name).to eq 'Country 2'
      expect(countries[1].name).to eq 'Country 1'
      expect(countries[2].name).to eq 'Country 3'
      expect(response).to redirect_to controls_master_countries_path
    end
  end

  describe 'Delete' do
    it 'should be able to delete.' do
      get :index, params: { locale: :en }
      util = assigns(:dynamic_scaffold_util)

      country = FactoryBot.create(:country)
      patch :sort_or_destroy, params: { locale: :en, submit_destroy: util.pkey_string(country) }

      expect(Country.find_by(id: country.id)).to be_nil
      expect(response).to redirect_to controls_master_countries_path
    end
    it 'should display error if you delete record that can not be deleted with foreign key constraints' do
      get :index, params: { locale: :en }
      util = assigns(:dynamic_scaffold_util)

      state = FactoryBot.create(:state)
      patch :sort_or_destroy, params: { locale: :en, submit_destroy: util.pkey_string(state.country) }

      expect(Country.find_by(id: state.country.id)).not_to be_nil
      expect(flash['dynamic_saffold_danger']).not_to be_nil
      expect(response).to redirect_to controls_master_countries_path
    end
  end

  describe 'Path Util' do
    it 'should be able to get path.' do
      get :index, params: { locale: :en }
      util = assigns(:dynamic_scaffold_util)

      expect(util.path_for(:index)).to eq '/en/controls/master/countries'
      expect(util.path_for(:new)).to eq '/en/controls/master/countries/new'
      expect(util.path_for(:sort_or_destroy)).to eq '/en/controls/master/countries/sort_or_destroy'
    end
  end
end
