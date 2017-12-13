require 'rails_helper'
RSpec.describe Controls::CountriesForPagenationController, type: :controller do
  describe 'Pagenation' do
    render_views
    it 'should limit the display count to the value of per_page.' do
      FactoryBot.create_list(:country, 15)
      get :index, params: { locale: :en }
      expect(response.body.scan(/<li class="resplist-row js-item-row">/).size).to eq 1
      expect(response.body).to match /<ul class="pagination/
    end
  end
end
