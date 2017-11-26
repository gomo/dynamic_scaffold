require 'rails_helper'

describe 'DynamicScaffold::Manager' do
  context '#displays' do
    it 'should output all columns by default.' do
      manager = DynamicScaffold::Manager.new Country
      countries = FactoryBot.create_list(:country, 3)
      displays = manager.displays
      expect(displays.size).to eq Country.column_names.size
      Country.column_names.each_index do |idx|
        countries.each do |country|
          expect(displays[idx].label(country)).to eq Country.human_attribute_name(Country.column_names[idx])
          expect(displays[idx].value(country)).to eq country.public_send(Country.column_names[idx])
        end
      end
    end
  end
end
