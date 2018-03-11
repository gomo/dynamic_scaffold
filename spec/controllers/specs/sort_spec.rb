require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'Sort' do
    it 'should be able to generate sequence number.' do
      controller.class.send(:dynamic_scaffold, Country) do |c|
        c.list.sorter sequence: :desc
      end
      
      get :index, params: { locale: :en }
      original_sorter = controller.dynamic_scaffold.list.sorter

      controller.dynamic_scaffold.list.sorter(sequence: :desc)
      controller.send(:reset_sequence, (1..5).to_a.size)
      expect(controller.send(:next_sequence!)).to eq 4
      expect(controller.send(:next_sequence!)).to eq 3
      expect(controller.send(:next_sequence!)).to eq 2
      expect(controller.send(:next_sequence!)).to eq 1
      expect(controller.send(:next_sequence!)).to eq 0

      controller.dynamic_scaffold.list.sorter(sequence: :asc)
      controller.send(:reset_sequence, (1..5).to_a.size)
      expect(controller.send(:next_sequence!)).to eq 0
      expect(controller.send(:next_sequence!)).to eq 1
      expect(controller.send(:next_sequence!)).to eq 2
      expect(controller.send(:next_sequence!)).to eq 3
      expect(controller.send(:next_sequence!)).to eq 4

      controller.dynamic_scaffold.list.sorter(original_sorter)
    end
    it 'should be able to sort.' do
      controller.class.send(:dynamic_scaffold, Country) do |c|
        c.list.sorter sequence: :desc
      end

      FactoryBot.create_list(:country, 3)
      countries = Country.all.order sequence: :desc

      expect(countries[0].name).to eq 'Country 3'
      expect(countries[1].name).to eq 'Country 2'
      expect(countries[2].name).to eq 'Country 1'

      pkeys = []
      pkeys << { id: countries[1].id }
      pkeys << { id: countries[0].id }
      pkeys << { id: countries[2].id }
      patch :sort, params: { locale: :en, pkeys: pkeys, submit_sort: '' }
      countries = Country.all.order sequence: :desc
      expect(countries[0].name).to eq 'Country 2'
      expect(countries[1].name).to eq 'Country 3'
      expect(countries[2].name).to eq 'Country 1'
      expect(response).to redirect_to controls_master_countries_path

      pkeys = []
      pkeys << { id: countries[0].id }
      pkeys << { id: countries[2].id }
      pkeys << { id: countries[1].id }
      patch :sort, params: { locale: 'ja', pkeys: pkeys, submit_sort: '' }
      countries = Country.all.order sequence: :desc
      expect(countries[0].name).to eq 'Country 2'
      expect(countries[1].name).to eq 'Country 1'
      expect(countries[2].name).to eq 'Country 3'
      expect(response).to redirect_to controls_master_countries_path
    end
  end
end
