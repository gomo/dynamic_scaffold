# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpecsController, type: :controller do
  render_views

  it 'styles every supported select helper, including grouped and time selects' do
    group = Struct.new(:name, :countries).new('Group', [Country.new(id: 1, name: 'Japan')])
    controller.class.send(:dynamic_scaffold, Country) do |c|
      c.form.item(:collection_select, :name, group.countries, :id, :name)
      c.form.item(:grouped_collection_select, :name, [group], :countries, :name, :id, :name)
      c.form.item(:date_select, :created_at)
      c.form.item(:datetime_select, :updated_at)
      c.form.item(:time_select, :updated_at)
    end

    get :new, params: { locale: :en }

    document = Nokogiri::HTML(response.body)
    selects = document.css('.ds-form select')
    expect(selects.size).to eq(12)
    selects.each do |select|
      expect(select['class'].split).to include('form-select')
      expect(select['class'].split).not_to include('form-control')
    end
    expect(document.css('optgroup[label="Group"] option').text).to eq('Japan')
  end

  it 'preserves explicit autocomplete settings and defaults only unspecified fields' do
    controller.class.send(:dynamic_scaffold, Country) do |c|
      c.form.item(:text_field, :name, autocomplete: 'email')
      c.form.item(:text_field, :sequence, 'autocomplete' => 'off')
      c.form.item(:text_field, :id)
    end

    get :new, params: { locale: :en }

    document = Nokogiri::HTML(response.body)
    expect(document.at_css('input[name="country[name]"]')['autocomplete']).to eq('email')
    expect(document.at_css('input[name="country[sequence]"]')['autocomplete']).to eq('off')
    expect(document.at_css('input[name="country[id]"]')['autocomplete']).to eq('new-password')
  end
end
