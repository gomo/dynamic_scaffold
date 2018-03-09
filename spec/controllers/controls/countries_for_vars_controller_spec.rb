require 'rails_helper'
RSpec.describe Controls::CountriesForVarsController, type: :controller do
  render_views
  context 'list' do
    it 'should display the same usec and controller_name on the page.' do
      get :index, params: { locale: :en }

      res = response.body.gsub(/\r\n|\r|\n| /, '').match(
        %r{class="vars_check"><li>(.*)</li><li>(.*)</li><li>(.*)</li></ul>}
      )
      expect(res).not_to be nil
      expect(res[1]).to eq res[2]
      expect(res[3]).to eq 'controls/countries_for_vars'
    end
  end

  context 'new' do
    it 'should display the same usec and controller_name on the page.' do
      get :new, params: { locale: :en }

      res = response.body.gsub(/\r\n|\r|\n| /, '').match(
        %r{class="vars_check"><li>(.*)</li><li>(.*)</li><li>(.*)</li></ul>}
      )
      expect(res).not_to be nil
      expect(res[1]).to eq res[2]
      expect(res[3]).to eq 'controls/countries_for_vars'
    end
  end

  context 'edit' do
    it 'should display the same usec and controller_name on the page.' do
      country = FactoryBot.create(:country)
      get :edit, params: { locale: :en, id: country.id }

      res = response.body.gsub(/\r\n|\r|\n| /, '').match(
        %r{class="vars_check"><li>(.*)</li><li>(.*)</li><li>(.*)</li></ul>}
      )
      expect(res).not_to be nil
      expect(res[1]).to eq res[2]
      expect(res[3]).to eq 'controls/countries_for_vars'
    end
  end
end
