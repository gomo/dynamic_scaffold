require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'Pagination' do
    render_views

    it 'should display all items when no pagenation.' do
      controller.class.send(:dynamic_scaffold, Country) {}
      FactoryBot.create_list(:country, 8)
      get :index, params: { locale: :en }
      expect(response.body.scan(/<li class="ds-list-row js-ds-list-row">/).size).to eq 8
      expect(response.body).not_to match(/<ul class="pagination/)
    end

    it 'should limit the display count to the value of per_page and display page navi.' do
      controller.class.send(:dynamic_scaffold, Country) do |c|
        c.list.pagination(
          per_page: 1
        )
      end

      FactoryBot.create_list(:country, 3)
      get :index, params: { locale: :en }
      expect(response.body.scan(/<li class="ds-list-row js-ds-list-row">/).size).to eq 1
      expect(response.body).to match(/<ul class="pagination/)
      expect(assigns(:records).length).to eq 1
    end

    it 'should have foobar parameter for page.' do
      controller.class.send(:dynamic_scaffold, Country) do |c|
        c.list.pagination(
          per_page: 1,
          param_name: :foobar
        )
      end

      FactoryBot.create_list(:country, 3)
      get :index, params: { locale: :en, foobar: 2 }
      expect(response.body).to match(/"\/en\/specs\?foobar=3"/)
    end

    it 'should return to the original page when you press the back button on the edit page.' do
      controller.class.send(:dynamic_scaffold, Country) do |c|
        c.list.pagination(
          per_page: 1
        )
      end

      countries = FactoryBot.create_list(:country, 3)
      get :index, params: { locale: :en, page: 3 }
      # The parameter name of the edit page is fixed as `page`.
      expect(response.body).to match(/href="\/en\/specs\/1\/edit\?page=3"/)
      # The page ID is assigned to the back button with the specified parameter name.
      get :edit, params: { locale: :en, id: countries[2].id, page: 3 }
      expect(response.body).to match(/href="\/en\/specs\?page=3"/)
    end
  end
end
