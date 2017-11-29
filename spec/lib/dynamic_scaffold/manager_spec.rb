require 'rails_helper'

class DynamicScaffoldSpecView
  extend ActionView::Context
  extend ActionView::Helpers::FormHelper
  extend ActionView::Helpers::CaptureHelper
  extend ActionView::Helpers::UrlHelper
  extend ActionView::Helpers::FormTagHelper
  extend ActionView::Helpers::TagHelper
  def self.protect_against_forgery?
    false
  end
end

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
      expect(display.value(country)).to eq country.fdate(:created_at, '%Y-%m-%d %H:%M:%S')
    end
  end

  context '#forms' do
    it 'should output all columns by default.' do
      manager = DynamicScaffold::Manager.new Country

      forms = manager.forms
      expect(forms.size).to eq Country.column_names.size

      country = FactoryBot.create(:country)
      DynamicScaffoldSpecView.form_with model: country, url: './create' do |form|
        expect(forms[0].label(form)).to eq 'Id'
        expect(forms[0].render(form)).to(
          eq "<input type=\"text\" value=\"#{country.id}\" name=\"country[id]\" />"
        )

        expect(forms[1].label(form)).to eq 'Name'
        expect(forms[1].render(form)).to(
          eq "<input type=\"text\" value=\"#{country.name}\" name=\"country[name]\" />"
        )

        expect(forms[2].label(form)).to eq 'Sequence'
        expect(forms[2].render(form)).to(
          eq "<input type=\"text\" value=\"#{country.sequence}\" name=\"country[sequence]\" />"
        )

        expect(forms[3].label(form)).to eq 'Created at'
        expect(forms[3].render(form)).to(
          eq "<input type=\"text\" value=\"#{country.created_at}\" name=\"country[created_at]\" />"
        )

        expect(forms[4].label(form)).to eq 'Updated at'
        expect(forms[4].render(form)).to(
          eq "<input type=\"text\" value=\"#{country.updated_at}\" name=\"country[updated_at]\" />"
        )
      end
    end

    it 'should be able to specify a label.' do
      country = FactoryBot.create(:country)
      manager = DynamicScaffold::Manager.new Country
      manager.add_form(:id, :text_field, 'FOOBAR')
      elem = manager.forms[0]
      DynamicScaffoldSpecView.form_with model: country, url: './create' do |form|
        expect(elem.label(form)).to eq 'FOOBAR'
      end
    end

    it 'should use the column name for the label if you omit it.' do
      country = FactoryBot.create(:country)
      manager = DynamicScaffold::Manager.new Country
      manager.add_form(:id, :text_field)
      elem = manager.forms[0]
      DynamicScaffoldSpecView.form_with model: country, url: './create' do |form|
        expect(elem.label(form)).to eq 'Id'
      end
    end
  end
end
