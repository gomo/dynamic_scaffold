require 'rails_helper'
RSpec.describe Controls::CountriesForCallbacksController, type: :controller do
  describe '#before_save' do
    it ':create' do
      post :create, params: { locale: :en, country: { name: 'foobar' } }
      country = assigns(:record)
      country.reload
      expect(country.name).to eq 'executed create before save!!'
    end
    it ':update' do
      country = FactoryBot.create(:country)
      country.name = 'foobar'
      patch :update, params: { locale: :en, country: country.attributes }
      country.reload
      expect(country.name).to eq 'executed update before save!!'
    end
    it ':each_sort' do
      countries = FactoryBot.create_list(:country, 3)

      pkeys = []
      pkeys << { id: countries[1].id }
      pkeys << { id: countries[0].id }
      pkeys << { id: countries[2].id }
      patch :sort_or_destroy, params: { locale: :en, pkeys: pkeys, submit_sort: '' }
      countries = Country.all.order sequence: :desc
      expect(countries[0].name).to eq 'executed each_sort 2 before save!!'
      expect(countries[1].name).to eq 'executed each_sort 1 before save!!'
      expect(countries[2].name).to eq 'executed each_sort 0 before save!!'
    end
  end
end
