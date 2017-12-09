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
    it ':sort' do
      countries = FactoryBot.create_list(:country, 3)

      pkeys = []
      pkeys << { id: countries[1].id }
      pkeys << { id: countries[0].id }
      pkeys << { id: countries[2].id }
      patch :sort_or_destroy, params: { locale: :en, pkeys: pkeys, submit_sort: '' }
      countries = Country.all.order sequence: :desc
      expect(countries[0].name).to eq 'executed sort 2 before save!!'
      expect(countries[1].name).to eq 'executed sort 1 before save!!'
      expect(countries[2].name).to eq 'executed sort 0 before save!!'
    end
    it ':destroy' do
      state = FactoryBot.create(:state)
      patch :sort_or_destroy, params: { locale: :en, submit_destroy: state.country.primary_key_value.to_json }
      expect(flash['dynamic_scaffold_danger']).to be_nil
      expect(response).to redirect_to controls_master_countries_for_callbacks_path
    end
  end
end
