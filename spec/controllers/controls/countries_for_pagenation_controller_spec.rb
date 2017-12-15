require 'rails_helper'
RSpec.describe Controls::CountriesForPagenationController, type: :controller do
  describe 'Pagenation' do
    render_views
    it 'should limit the display count to the value of per_page and display page navi.' do
      FactoryBot.create_list(:country, 3)
      get :index, params: { locale: :en }
      expect(response.body.scan(/<li class="resplist-row js-item-row">/).size).to eq 1
      expect(response.body).to match(/<ul class="pagination/)
    end

    it 'should have foobar parameter for page.' do
      FactoryBot.create_list(:country, 3)
      countries = Country.all
      get :index, params: { locale: :en, foobar: 2 }
      expect(response.body).to match(/<a remote="false" class="page-link">2<\/a>/)
      expect(response.body).to match(/<div class="resplist-value">#{countries[1].name}<\/div>/)
      expect(response.body).to match(/\?foobar=3">3<\/a>/)
    end

    it 'should return to the original page when you press the back button on the edit page.' do
      countries = FactoryBot.create_list(:country, 3)
      get :index, params: { locale: :en, foobar: 3 }
      # The parameter name of the edit page is fixed as `page`.
      expect(response.body).to match(/href="\/en\/controls\/master\/countries_for_pagenation\/edit\?key%5Bid%5D=1&amp;page=3"/)
      # The page ID is assigned to the back button with the specified parameter name.
      get :edit, params: { locale: :en, key: countries[2].primary_key_value, page: 3 }
      expect(response.body).to match(/href="\/en\/controls\/master\/countries_for_pagenation\?foobar=3"/)
    end
  end
end
