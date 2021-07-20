require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'Buttons' do
    render_views
    describe 'add_button' do
      it 'should disable add button when set add_button to false.' do
        controller.class.send(:dynamic_scaffold, Country) do |c|
          c.list.add_button = false
        end

        get :index, params: { locale: :en }
        doc = Nokogiri::HTML(response.body)
        expect(doc.css('.spec-ds-add').length).to eq 0
      end

      it 'should be called in view scope when pass the block.' do
        controller.class.send(:dynamic_scaffold, Country) do |c|
          c.list.add_button do
            params[:foo] == 'bar'
          end
        end

        get :index, params: { locale: :en, foo: 'quz' }
        doc = Nokogiri::HTML(response.body)
        expect(doc.css('.spec-ds-add').length).to eq 0
      end
    end

    describe 'edit_buttons' do
      it 'should disable all edit buttons when set edit_buttons to false.' do
        controller.class.send(:dynamic_scaffold, Country) do |c|
          c.list.edit_buttons = false
        end

        FactoryBot.create_list(:country, 3)

        get :index, params: { locale: :en }
        doc = Nokogiri::HTML(response.body)

        list = doc.css('.ds-list-row')
        expect(list.length).to eq 3

        list.each do |row|
          expect(row.css('.spec-ds-edit').length).to eq 0
        end
      end
      it 'should edit buttons when the passed block return false.' do
        controller.class.send(:dynamic_scaffold, Country) do |c|
          c.list.edit_buttons do |record|
            record.name == 'foo'
          end
        end

        FactoryBot.create(:country, name: 'foo')
        FactoryBot.create(:country, name: 'bar')

        get :index, params: { locale: :en }
        doc = Nokogiri::HTML(response.body)

        list = doc.css('.ds-list-row')
        expect(list.length).to eq 2

        row = list.find {|r| r.css('.ds-list-item:nth-child(2) .ds-list-value').text == 'foo' }
        expect(row.css('.spec-ds-edit').length).to eq 1

        row = list.find {|r| r.css('.ds-list-item:nth-child(2) .ds-list-value').text == 'bar' }
        expect(row.css('.spec-ds-edit').length).to eq 0
      end
    end
  end
end
