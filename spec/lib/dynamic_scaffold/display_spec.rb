require 'rails_helper'

describe 'DynamicScaffold::Display' do
  context 'Attribute' do
    it 'should be able to specify a label.' do
      country = FactoryBot.create(:country)
      display = DynamicScaffold::Display::Attribute.new :id, 'FOOBAR'
      expect(display.label(country)).to eq 'FOOBAR'
    end
    it 'should use the column name for the label if you omit it.' do
      country = FactoryBot.create(:country)
      display = DynamicScaffold::Display::Attribute.new :id
      expect(display.label(country)).to eq Country.human_attribute_name :id
    end
    it 'should be able to retrieve its value if you specify a column name.' do
      country = FactoryBot.create(:country)
      display = DynamicScaffold::Display::Attribute.new :id
      expect(display.value(country)).to eq country.id
    end
    it 'should send the attribute name to the model and get its value.' do
      country = FactoryBot.create(:country)
      display = DynamicScaffold::Display::Attribute.new :my_attribute
      expect(display.value(country)).to eq 'My attribute value'
    end
  end
end
