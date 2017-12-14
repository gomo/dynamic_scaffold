require 'rails_helper'
RSpec.describe Controls::CountriesForPagenationController, type: :controller do
  describe 'Pagenation' do
    render_views
    it 'should limit the display count to the value of per_page.' do
      FactoryBot.create_list(:country, 15)
      get :index, params: { locale: :en }
      expect(response.body.scan(/<li class="resplist-row js-item-row">/).size).to eq 1
      expect(response.body).to match(/<ul class="pagination/)
    end

    it 'should return to the original page when you press the back button on the edit page.' do
      countries = FactoryBot.create_list(:country, 3)
      get :index, params: { locale: :en, page: 3 }
      expect(response.body).to match(/href="\/en\/controls\/master\/countries_for_pagenation\/edit\?key%5Bid%5D=1&amp;page=3"/)

      get :edit, params: { locale: :en, key: countries[2].primary_key_value, page: 3 }
      expect(response.body).to match(/href="\/en\/controls\/master\/countries_for_pagenation\?page=3"/)
    end
  end
end
