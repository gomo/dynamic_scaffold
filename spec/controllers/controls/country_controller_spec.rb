require 'rails_helper'

RSpec.describe Controls::CountryController, type: :controller do
  describe 'Sort' do
    it 'should be able to sort.' do
      manager = DynamicScaffold::Manager.new Country

      FactoryBot.create_list(:country, 3)
      countries = Country.all.order sequence: :desc

      expect(countries[0].name).to eq 'Country 3'
      expect(countries[1].name).to eq 'Country 2'
      expect(countries[2].name).to eq 'Country 1'

      pkeys = []
      pkeys << manager.list.sorter_param(countries[1])
      pkeys << manager.list.sorter_param(countries[0])
      pkeys << manager.list.sorter_param(countries[2])
      patch :sort, params: { locale: 'ja', pkeys: pkeys }
      countries = Country.all.order sequence: :desc
      expect(countries[0].name).to eq 'Country 2'
      expect(countries[1].name).to eq 'Country 3'
      expect(countries[2].name).to eq 'Country 1'

      pkeys = []
      pkeys << manager.list.sorter_param(countries[0])
      pkeys << manager.list.sorter_param(countries[2])
      pkeys << manager.list.sorter_param(countries[1])
      patch :sort, params: { locale: 'ja', pkeys: pkeys }
      countries = Country.all.order sequence: :desc
      expect(countries[0].name).to eq 'Country 2'
      expect(countries[1].name).to eq 'Country 1'
      expect(countries[2].name).to eq 'Country 3'
    end
  end
end
