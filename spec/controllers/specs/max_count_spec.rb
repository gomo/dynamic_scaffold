# frozen_string_literal: true

require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'Max count' do
    render_views
    it 'should not be able to add beyond the set value.' do
      controller.class.send(:dynamic_scaffold, Country) do |c|
        c.max_count 1, lock: true
        c.list.item(:name, style: 'width: 120px;')
        c.form.item(:text_field, :name)
        c.form.item(:text_field, :sequence)
      end

      get :index, params: { locale: :en }
      doc = Nokogiri::HTML(response.body)
      btn_add = doc.css('.spec-ds-add.disabled').first
      expect(btn_add).to be nil

      get :new, params: { locale: :en }
      expect(response.status).to eq(200)

      expect do
        post :create, params: { locale: :en, country: {
          name: 'foobar',
          sequence: 1
        } }
      end.to change(Country, :count).by(1)

      get :index, params: { locale: :en }
      doc = Nokogiri::HTML(response.body)
      btn_add = doc.css('.spec-ds-add.disabled').first
      expect(btn_add).not_to be nil

      expect do
        get :new, params: { locale: :en }
      end.to raise_error(DynamicScaffold::Error::InvalidOperation)

      expect do
        post :create, params: { locale: :en, country: {
          name: 'foobar',
          sequence: 1
        } }
      end.to raise_error(DynamicScaffold::Error::InvalidOperation)
         .and change(Country, :count).by(0)
    end
  end
end
