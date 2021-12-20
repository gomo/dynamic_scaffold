# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  context 'DynamicScaffold::Config#list.items' do
    it 'should output all columns by default.' do
      config = DynamicScaffold::Config.new(Country, nil)

      items = config.list.items
      expect(items.size).to eq Country.column_names.size

      countries = FactoryBot.create_list(:country, 3)
      Country.column_names.each_index do |idx|
        countries.each do |country|
          expect(items[idx].label).to eq Country.human_attribute_name(Country.column_names[idx])
          expect(items[idx].value(helper, country)).to eq country.public_send(Country.column_names[idx])
        end
      end
    end
  end

  context 'DynamicScaffold::Config::List::Item' do
    context 'Attribute' do
      it 'should be able to specify a label.' do
        config = DynamicScaffold::Config.new(Country, nil)
        config.list.item(:id).label('FOOBAR')
        item = config.list.items[0]
        expect(item.label).to eq 'FOOBAR'
      end
      it 'should use the column name for the label if you omit it.' do
        config = DynamicScaffold::Config.new(Country, nil)
        config.list.item(:id)
        item = config.list.items[0]
        expect(item.label).to eq Country.human_attribute_name :id
      end
      it 'should be able to retrieve its value if you specify a column name.' do
        country = FactoryBot.create(:country)
        config = DynamicScaffold::Config.new(Country, nil)
        config.list.item(:id)
        item = config.list.items[0]
        expect(item.value(helper, country)).to eq country.id
      end
      it 'should send the attribute name to the model and get its value.' do
        country = FactoryBot.create(:country)
        config = DynamicScaffold::Config.new(Country, nil)
        config.list.item(:my_attribute)
        item = config.list.items[0]
        expect(item.value(helper, country)).to eq 'My attribute value'
      end
      it 'should be able to generate HTML attributes with the last hash argument.' do
        config = DynamicScaffold::Config.new(Country, nil)
        config.list.item(
          :id,
          class: 'foobar',
          'data-foo' => 'data foo value',
          style: 'width: 100px;'
        )
        item = config.list.items[0]
        expect(item.classnames).to eq 'foobar'
        expect(item.html_attributes).to eq 'data-foo' => 'data foo value', style: 'width: 100px;'
      end
    end
    context 'Block' do
      it 'should call block in the context of view when passing block.' do
        config = DynamicScaffold::Config.new(Country, nil)
        config.list.item do |record, _name|
          content_tag :a, record.name, href: 'foobar'
        end
        item = config.list.items[0]
        country = FactoryBot.create(:country)
        expect(item.value(helper, country)).to eq "<a href=\"foobar\">#{country.name}</a>"
      end
      it 'should be able to use a combination of attribute names and blocks.' do
        config = DynamicScaffold::Config.new(Country, nil)
        config.list.item :created_at do |record, name|
          record.fdate name, '%Y-%m-%d %H:%M:%S'
        end
        item = config.list.items[0]
        country = FactoryBot.create(:country)
        expect(item.value(helper, country)).to eq country.fdate(:created_at, '%Y-%m-%d %H:%M:%S')
      end
      it 'should be able to pass blocks to Label.' do
        config = DynamicScaffold::Config.new(Country, nil)
        config.list.item do |record, _name|
          content_tag :a, record.name, href: 'foobar'
        end.label('To State')
        item = config.list.items[0]
        country = FactoryBot.create(:country)
        expect(item.label).to eq 'To State'
        expect(item.value(helper, country)).to eq "<a href=\"foobar\">#{country.name}</a>"
      end
      it 'should return nil for the label if you omit attribute name and label.' do
        config = DynamicScaffold::Config.new(Country, nil)
        config.list.item {|record| }
        item = config.list.items[0]
        expect(item.label).to be_nil
      end
      it 'should return attribute name for the label with name without label.' do
        config = DynamicScaffold::Config.new(Country, nil)
        config.list.item(:id) {|record, name| }
        item = config.list.items[0]
        expect(item.label).to eq 'Id'
      end
      it 'should be able to generate HTML attributes with the last hash argument.' do
        config = DynamicScaffold::Config.new(Country, nil)
        config.list.item(
          class: 'foobar',
          'data-foo' => 'data foo value',
          style: 'width: 100px;'
        ).label('FOOBAR') {|record| }
        item = config.list.items[0]
        expect(item.label).to eq 'FOOBAR'
        expect(item.html_attributes).to eq 'data-foo' => 'data foo value', style: 'width: 100px;'
      end
    end
  end
  context 'DynamicScaffold::Config#list.pagination' do
    it 'should be able to acquire the setting value.' do
      config = DynamicScaffold::Config.new(Country, nil)

      expect(config.list.pagination).to be nil

      config.list.pagination(
        per_page: 10,
        window: 4,
        outer_window: 1,
        left: 0,
        right: 0,
        param_name: :foobar,
        total_count: false,
        end_buttons: false,
        neighbor_buttons: true,
        gap_buttons: false
      )

      expect(config.list.pagination).to be_a DynamicScaffold::List::Pagination

      expect(config.list.pagination.kaminari_options).to eq(
        window: 4,
        outer_window: 1,
        left: 0,
        right: 0,
        param_name: :foobar
      )

      expect(config.list.pagination.per_page).to eq 10
      expect(config.list.pagination.total_count).to be false
      expect(config.list.pagination.end_buttons).to be false
      expect(config.list.pagination.neighbor_buttons).to be true
      expect(config.list.pagination.gap_buttons).to be false
      expect(config.list.pagination.param_name).to eq :foobar
    end
  end
end
