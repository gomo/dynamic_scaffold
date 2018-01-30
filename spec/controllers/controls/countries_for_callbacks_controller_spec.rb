require 'rails_helper'
RSpec.describe Controls::CountriesForCallbacksController, type: :controller do
  describe '#before_save' do
    it ':create' do
      post :create, params: { locale: :en, country: { name: 'foobar' } }
      country = assigns(:record)
      country.reload
      expect(country.name).to eq 'executed create before save!! [empty:foobar]'
    end
    it ':update' do
      country = FactoryBot.create(:country)
      prev_name = country.name
      country.name = 'foobar'
      patch :update, params: { locale: :en, id: country.id, country: country.attributes }
      country.reload
      expect(country.name).to eq "executed update before save!! [#{prev_name}:foobar]"
    end
    it ':sort' do
      prev_countries = FactoryBot.create_list(:country, 3)

      pkeys = []
      pkeys << { id: prev_countries[1].id }
      pkeys << { id: prev_countries[0].id }
      pkeys << { id: prev_countries[2].id }
      patch :sort, params: { locale: :en, pkeys: pkeys, submit_sort: '' }
      countries = Country.all.order sequence: :desc
      expect(countries[0].name).to eq "executed sort before save!! [#{prev_countries[1].sequence}:2]"
      expect(countries[1].name).to eq "executed sort before save!! [#{prev_countries[0].sequence}:1]"
      expect(countries[2].name).to eq "executed sort before save!! [#{prev_countries[2].sequence}:0]"
    end
    it ':destroy' do
      state = FactoryBot.create(:state)
      delete :destroy, params: {
        locale: :en,
        id: state.country.id
      }
      expect(flash['dynamic_scaffold_danger']).to be_nil
      expect(response).to redirect_to controls_master_countries_for_callbacks_path
    end
  end
  describe '#before_fetch' do
    it '' do
      FactoryBot.create_list(:country, 3)
      get :index, params: { locale: :en }
      records = assigns(:records)
      expect(records.count).to eq 0
    end
  end
end
