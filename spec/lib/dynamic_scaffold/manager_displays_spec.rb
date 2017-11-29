require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  context 'DynamicScaffold::Manager#displays' do
    it 'should output all columns by default.' do
      manager = DynamicScaffold::Manager.new Country

      displays = manager.displays
      expect(displays.size).to eq Country.column_names.size

      countries = FactoryBot.create_list(:country, 3)
      Country.column_names.each_index do |idx|
        countries.each do |country|
          expect(displays[idx].label(country)).to eq Country.human_attribute_name(Country.column_names[idx])
          expect(displays[idx].value(country, helper)).to eq country.public_send(Country.column_names[idx])
        end
      end
    end
  end

  context 'DynamicScaffold::Manager#add_display' do
    context 'Attribute' do
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
        expect(display.value(country, helper)).to eq country.id
      end
      it 'should send the attribute name to the model and get its value.' do
        country = FactoryBot.create(:country)
        manager = DynamicScaffold::Manager.new Country
        manager.add_display(:my_attribute)
        display = manager.displays[0]
        expect(display.value(country, helper)).to eq 'My attribute value'
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
        expect(display.classnames).to eq 'foobar'
        expect(display.html_attributes).to eq 'data-foo' => 'data foo value', style: 'width: 100px;'
      end
      it 'should be used as an argument of the method to be sent when the second argument is an array.' do
        manager = DynamicScaffold::Manager.new Country
        manager.add_display(
          :fdate,
          [:created_at, '%Y-%m-%d %H:%M:%S'],
          'Create Date'
        )
        display = manager.displays[0]
        country = FactoryBot.create(:country)
        expect(display.label(country)).to eq 'Create Date'
        expect(display.value(country, helper)).to eq country.fdate(:created_at, '%Y-%m-%d %H:%M:%S')
      end
    end
    context 'Block' do
      it 'should call block in the context of view when passing block.' do
        manager = DynamicScaffold::Manager.new Country
        manager.add_display 'To State' do |record|
          content_tag :a, record.name, href: 'foobar'
        end
        display = manager.displays[0]
        country = FactoryBot.create(:country)
        expect(display.value(country, helper)).to eq "<a href=\"foobar\">#{country.name}</a>"
      end
      it 'should be able to specify a label.' do
        manager = DynamicScaffold::Manager.new Country
        manager.add_display('To State') {|record| }
        display = manager.displays[0]
        country = FactoryBot.create(:country)
        expect(display.label(country)).to eq 'To State'
      end
      it 'should return nil for the label if you omit it.' do
        manager = DynamicScaffold::Manager.new Country
        manager.add_display {|record| }
        display = manager.displays[0]
        country = FactoryBot.create(:country)
        expect(display.label(country)).to be_nil
      end
      it 'should be able to generate HTML attributes with the last hash argument.' do
        country = FactoryBot.create(:country)

        # no lable
        manager = DynamicScaffold::Manager.new Country
        manager.add_display(
          class: 'foobar',
          'data-foo' => 'data foo value',
          style: 'width: 100px;'
        ) {|record| }

        display = manager.displays[0]
        expect(display.label(country)).to be_nil
        expect(display.html_attributes).to eq 'data-foo' => 'data foo value', style: 'width: 100px;'

        # with lable
        manager = DynamicScaffold::Manager.new Country
        manager.add_display(
          'FOOBAR',
          class: 'foobar',
          'data-foo' => 'data foo value',
          style: 'width: 100px;'
        ) {|record| }
        display = manager.displays[0]
        expect(display.label(country)).to eq 'FOOBAR'
        expect(display.html_attributes).to eq 'data-foo' => 'data foo value', style: 'width: 100px;'
      end
    end
  end
end
