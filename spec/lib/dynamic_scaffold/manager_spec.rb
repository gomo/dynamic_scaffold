require 'rails_helper'

describe 'DynamicScaffold::Manager' do
  context '#displays' do
    it 'should output all columns by default.' do
      manager = DynamicScaffold::Manager.new Country

      displays = manager.displays
      expect(displays.size).to eq Country.column_names.size

      countries = FactoryBot.create_list(:country, 3)
      Country.column_names.each_index do |idx|
        countries.each do |country|
          expect(displays[idx].label(country)).to eq Country.human_attribute_name(Country.column_names[idx])
          expect(displays[idx].value(country)).to eq country.public_send(Country.column_names[idx])
        end
      end
    end
  end

  context '#add_display' do
    it 'should be able to specify a label.' do
      country = FactoryBot.create(:country)
      manager = DynamicScaffold::Manager.new Country
      manager.add_display(:id, 'FOOBAR')
      display = manager.displays[0]
      expect(display.label(country)).to eq 'FOOBAR'
    end
    it 'should use the column name for the label if you omit it.' do
      country = FactoryBot.create(:country)
      manager = DynamicScaffold::Manager.new Country
      manager.add_display(:id)
      display = manager.displays[0]
      expect(display.label(country)).to eq Country.human_attribute_name :id
    end
    it 'should be able to retrieve its value if you specify a column name.' do
      country = FactoryBot.create(:country)
      manager = DynamicScaffold::Manager.new Country
      manager.add_display(:id)
      display = manager.displays[0]
      expect(display.value(country)).to eq country.id
    end
    it 'should send the attribute name to the model and get its value.' do
      country = FactoryBot.create(:country)
      manager = DynamicScaffold::Manager.new Country
      manager.add_display(:my_attribute)
      display = manager.displays[0]
      expect(display.value(country)).to eq 'My attribute value'
    end
    it 'should be able to generate HTML attributes with the last hash argument.' do
      manager = DynamicScaffold::Manager.new Country
      manager.add_display(
        :id,
        class: 'foobar',
        'data-foo' => 'data foo value',
        style: 'width: 100px;'
      )
      display = manager.displays[0]
      expect(display.class_attr).to eq 'class="foobar"'
      expect(display.html_attr).to eq 'data-foo="data foo value" style="width: 100px;"'
    end
  end
end
