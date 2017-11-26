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
    it 'No block' do
      manager = DynamicScaffold::Manager.new Country
      manager.add_display(
        :id,
        'ID',
        class: 'foobar',
        'data-foo' => 'data foo value',
        style: 'width: 100px;'
      )

      display = manager.displays[0]
      expect(display).to be_a(DynamicScaffold::Display::Attribute)

      country = FactoryBot.create(:country)
      expect(display.label(country)).to eq 'ID'
      expect(display.value(country)).to eq country.id
      expect(display.class_attr).to eq 'class="foobar"'
      expect(display.html_attr).to eq 'data-foo="data foo value" style="width: 100px;"'
    end
    it 'block' do
      manager = DynamicScaffold::Manager.new Country
      manager.add_display(
        'Name',
        class: 'foobar',
        'data-foo' => 'data foo value',
        style: 'width: 100px;'
      ) do |country|
        country.name
      end

      display = manager.displays[0]
      expect(display).to be_a(DynamicScaffold::Display::Block)

      country = FactoryBot.create(:country)
      expect(display.label(country)).to eq 'Name'
      expect(display.value(country)).to eq country.name
      expect(display.class_attr).to eq 'class="foobar"'
      expect(display.html_attr).to eq 'data-foo="data foo value" style="width: 100px;"'
    end
  end
end
