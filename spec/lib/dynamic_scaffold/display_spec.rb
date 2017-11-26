require 'rails_helper'

describe 'DynamicScaffold::Display' do
  context 'Attribute' do
    it 'should send the attribute name to the model and get its value.' do
      country = FactoryBot.create(:country)
      display = DynamicScaffold::Display::Attribute.new :id, label: 'ID'
      expect(display.label(country)).to eq 'ID'
      expect(display.value(country)).to eq country.id
    end

    it 'should use the column name for the label if you omit the label.' do
      country = FactoryBot.create(:country)
      display = DynamicScaffold::Display::Attribute.new :id
      expect(display.label(country)).to eq Country.human_attribute_name :id
      expect(display.value(country)).to eq country.id
    end
  end
end
