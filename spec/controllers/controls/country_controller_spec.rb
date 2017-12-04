require 'rails_helper'
RSpec.describe Controls::CountryController, type: :controller do
  describe 'Sort' do
    it 'should be able to sort.' do
      get :index, params: { locale: :en, trailing_slash: true }
      util = assigns(:dynamic_scaffold_util)

      FactoryBot.create_list(:country, 3)
      countries = Country.all.order sequence: :desc

      expect(countries[0].name).to eq 'Country 3'
      expect(countries[1].name).to eq 'Country 2'
      expect(countries[2].name).to eq 'Country 1'

      pkeys = []
      pkeys << util.sorter_param(countries[1])
      pkeys << util.sorter_param(countries[0])
      pkeys << util.sorter_param(countries[2])
      patch :sort, params: { locale: :en, pkeys: pkeys }
      countries = Country.all.order sequence: :desc
      expect(countries[0].name).to eq 'Country 2'
      expect(countries[1].name).to eq 'Country 3'
      expect(countries[2].name).to eq 'Country 1'

      pkeys = []
      pkeys << util.sorter_param(countries[0])
      pkeys << util.sorter_param(countries[2])
      pkeys << util.sorter_param(countries[1])
      patch :sort, params: { locale: 'ja', pkeys: pkeys }
      countries = Country.all.order sequence: :desc
      expect(countries[0].name).to eq 'Country 2'
      expect(countries[1].name).to eq 'Country 1'
      expect(countries[2].name).to eq 'Country 3'
    end
  end

  describe 'Path Util' do
    it 'should be able to get path.' do
      get :index, params: { locale: :en, trailing_slash: true }
      util = assigns(:dynamic_scaffold_util)

      expect(util.path_for(:index)).to eq '/en/controls/master/country/'
      expect(util.path_for(:new)).to eq '/en/controls/master/country/new'
      expect(util.path_for(:sort)).to eq '/en/controls/master/country/sort'
    end
  end
end
