require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  context 'DynamicScaffold::Manager#list.items' do
    it 'should output all columns by default.' do
      manager = DynamicScaffold::Manager.new Country

      items = manager.list.items
      expect(items.size).to eq Country.column_names.size

      countries = FactoryBot.create_list(:country, 3)
      Country.column_names.each_index do |idx|
        countries.each do |country|
          expect(items[idx].label(country)).to eq Country.human_attribute_name(Country.column_names[idx])
          expect(items[idx].value(country, helper)).to eq country.public_send(Country.column_names[idx])
        end
      end
    end
  end

  context 'DynamicScaffold::Manager::List::Item' do
    context 'Attribute' do
      it 'should be able to specify a label.' do
        country = FactoryBot.create(:country)
        manager = DynamicScaffold::Manager.new Country
        manager.list.item(:id, 'FOOBAR')
        item = manager.list.items[0]
        expect(item.label(country)).to eq 'FOOBAR'
      end
      it 'should use the column name for the label if you omit it.' do
        country = FactoryBot.create(:country)
        manager = DynamicScaffold::Manager.new Country
        manager.list.item(:id)
        item = manager.list.items[0]
        expect(item.label(country)).to eq Country.human_attribute_name :id
      end
      it 'should be able to retrieve its value if you specify a column name.' do
        country = FactoryBot.create(:country)
        manager = DynamicScaffold::Manager.new Country
        manager.list.item(:id)
        item = manager.list.items[0]
        expect(item.value(country, helper)).to eq country.id
      end
      it 'should send the attribute name to the model and get its value.' do
        country = FactoryBot.create(:country)
        manager = DynamicScaffold::Manager.new Country
        manager.list.item(:my_attribute)
        item = manager.list.items[0]
        expect(item.value(country, helper)).to eq 'My attribute value'
      end
      it 'should be able to generate HTML attributes with the last hash argument.' do
        manager = DynamicScaffold::Manager.new Country
        manager.list.item(
          :id,
          class: 'foobar',
          'data-foo' => 'data foo value',
          style: 'width: 100px;'
        )
        item = manager.list.items[0]
        expect(item.classnames).to eq 'foobar'
        expect(item.html_attributes).to eq 'data-foo' => 'data foo value', style: 'width: 100px;'
      end
    end
    context 'Block' do
      it 'should call block in the context of view when passing block.' do
        manager = DynamicScaffold::Manager.new Country
        manager.list.item 'To State' do |record|
          content_tag :a, record.name, href: 'foobar'
        end
        item = manager.list.items[0]
        country = FactoryBot.create(:country)
        expect(item.value(country, helper)).to eq "<a href=\"foobar\">#{country.name}</a>"
      end
      it 'should be able to specify a label.' do
        manager = DynamicScaffold::Manager.new Country
        manager.list.item('To State') {|record| }
        item = manager.list.items[0]
        country = FactoryBot.create(:country)
        expect(item.label(country)).to eq 'To State'
      end
      it 'should return nil for the label if you omit it.' do
        manager = DynamicScaffold::Manager.new Country
        manager.list.item {|record| }
        item = manager.list.items[0]
        country = FactoryBot.create(:country)
        expect(item.label(country)).to be_nil
      end
      it 'should be able to generate HTML attributes with the last hash argument.' do
        country = FactoryBot.create(:country)

        # no lable
        manager = DynamicScaffold::Manager.new Country
        manager.list.item(
          class: 'foobar',
          'data-foo' => 'data foo value',
          style: 'width: 100px;'
        ) {|record| }

        item = manager.list.items[0]
        expect(item.label(country)).to be_nil
        expect(item.html_attributes).to eq 'data-foo' => 'data foo value', style: 'width: 100px;'

        # with lable
        manager = DynamicScaffold::Manager.new Country
        manager.list.item(
          'FOOBAR',
          class: 'foobar',
          'data-foo' => 'data foo value',
          style: 'width: 100px;'
        ) {|record| }
        item = manager.list.items[0]
        expect(item.label(country)).to eq 'FOOBAR'
        expect(item.html_attributes).to eq 'data-foo' => 'data foo value', style: 'width: 100px;'
      end
    end
  end
end
