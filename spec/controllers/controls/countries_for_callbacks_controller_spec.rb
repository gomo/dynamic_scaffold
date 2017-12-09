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
    # it ':each_sort' do
    #   country = FactoryBot.create(:country)
    #   country.name = 'foobar'
    #   patch :update, params: { locale: :en, country: country.attributes }
    #   country.reload
    #   expect(country.name).to eq 'executed update before save!!'
    # end
  end
end
