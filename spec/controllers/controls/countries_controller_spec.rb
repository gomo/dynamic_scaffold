require 'rails_helper'
RSpec.describe Controls::CountriesController, type: :controller do
  describe 'Sort' do
    it 'should be able to generate sequence number.' do
      original_sorter = controller.class.dynamic_scaffold_config.list.sorter

      controller.class.dynamic_scaffold_config.list.sorter(sequence: :desc)
      controller.send(:reset_sequence, (1..5).to_a.size)
      expect(controller.send(:next_sequence!)).to eq 4
      expect(controller.send(:next_sequence!)).to eq 3
      expect(controller.send(:next_sequence!)).to eq 2
      expect(controller.send(:next_sequence!)).to eq 1
      expect(controller.send(:next_sequence!)).to eq 0

      controller.class.dynamic_scaffold_config.list.sorter(sequence: :asc)
      controller.send(:reset_sequence, (1..5).to_a.size)
      expect(controller.send(:next_sequence!)).to eq 0
      expect(controller.send(:next_sequence!)).to eq 1
      expect(controller.send(:next_sequence!)).to eq 2
      expect(controller.send(:next_sequence!)).to eq 3
      expect(controller.send(:next_sequence!)).to eq 4

      controller.class.dynamic_scaffold_config.list.sorter(original_sorter)
    end
    it 'should be able to sort.' do
      FactoryBot.create_list(:country, 3)
      countries = Country.all.order sequence: :desc

      expect(countries[0].name).to eq 'Country 3'
      expect(countries[1].name).to eq 'Country 2'
      expect(countries[2].name).to eq 'Country 1'

      pkeys = []
      pkeys << { id: countries[1].id }
      pkeys << { id: countries[0].id }
      pkeys << { id: countries[2].id }
      patch :sort_or_destroy, params: { locale: :en, pkeys: pkeys, submit_sort: '' }
      countries = Country.all.order sequence: :desc
      expect(countries[0].name).to eq 'Country 2'
      expect(countries[1].name).to eq 'Country 3'
      expect(countries[2].name).to eq 'Country 1'
      expect(response).to redirect_to controls_master_countries_path

      pkeys = []
      pkeys << { id: countries[0].id }
      pkeys << { id: countries[2].id }
      pkeys << { id: countries[1].id }
      patch :sort_or_destroy, params: { locale: 'ja', pkeys: pkeys, submit_sort: '' }
      countries = Country.all.order sequence: :desc
      expect(countries[0].name).to eq 'Country 2'
      expect(countries[1].name).to eq 'Country 1'
      expect(countries[2].name).to eq 'Country 3'
      expect(response).to redirect_to controls_master_countries_path
    end
  end

  describe 'Delete' do
    it 'should be able to delete.' do
      country = FactoryBot.create(:country)
      patch :sort_or_destroy, params: { locale: :en, submit_destroy: controller.send(:primary_key_value, country).to_json }

      expect(Country.find_by(id: country.id)).to be_nil
      expect(response).to redirect_to controls_master_countries_path
    end
    it 'should display error if you delete record that can not be deleted with foreign key constraints' do
      state = FactoryBot.create(:state)
      patch :sort_or_destroy, params: {
        locale: :en,
        submit_destroy: controller.send(:primary_key_value, state.country).to_json
      }

      expect(Country.find_by(id: state.country.id)).not_to be_nil
      expect(flash['dynamic_scaffold_danger']).not_to be_nil
      expect(response).to redirect_to controls_master_countries_path
    end
  end

  describe '#dynamic_scaffold_path' do
    it 'should be able to get path.' do
      get :index, params: { locale: :en }
      expect(controller.send(:dynamic_scaffold_path, :index)).to eq '/en/controls/master/countries'
      expect(controller.send(:dynamic_scaffold_path, :new)).to eq '/en/controls/master/countries/new'
      expect(controller.send(:dynamic_scaffold_path, :sort_or_destroy)).to eq '/en/controls/master/countries/sort_or_destroy'
      expect(controller.send(:dynamic_scaffold_path, :update)).to eq '/en/controls/master/countries/update'
    end
  end

  describe 'No Pagenation' do
    render_views
    it 'should display all items.' do
      FactoryBot.create_list(:country, 8)
      get :index, params: { locale: :en }
      expect(response.body.scan(/<li class="resplist-row js-item-row">/).size).to eq 8
      expect(response.body).not_to match(/<ul class="pagination/)
    end
  end
end
