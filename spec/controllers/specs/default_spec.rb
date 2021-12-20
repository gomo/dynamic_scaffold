# frozen_string_literal: true

require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'Default' do
    render_views
    it 'should be able to set the value on new action.' do
      controller.class.send(:dynamic_scaffold, Country) do |c|
        c.form.item(:text_field, :name, id: 'country_name').default('HOGEHOGE')
      end

      get :new, params: { locale: :en }

      doc = Nokogiri::HTML(response.body)
      expect(doc.css('input#country_name').first['value']).to eq 'HOGEHOGE'
    end

    it 'should also accept block.' do
      controller.class.send(:dynamic_scaffold, Country) do |c|
        c.form.item(:text_field, :name, id: 'country_name').default do
          params[:foo]
        end
      end

      get :new, params: { locale: :en, foo: :bar }

      doc = Nokogiri::HTML(response.body)
      expect(doc.css('input#country_name').first['value']).to eq 'bar'
    end
  end
end
