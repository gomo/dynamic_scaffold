# frozen_string_literal: true

require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'List Title' do
    it 'should display nothing when don\'t call.' do
      controller.class.send(:dynamic_scaffold, Country) {}

      FactoryBot.create_list(:country, 3)
      get :index, params: { locale: :en }

      expect(dynamic_scaffold.list.title?).to be false
    end

    it 'should display the column value when passing the column name.' do
      controller.class.send(:dynamic_scaffold, Country) do |c|
        c.list.title(:name)
      end
      countries = FactoryBot.create_list(:country, 3)
      get :index, params: { locale: :en }

      expect(dynamic_scaffold.list.title?).to be true
      countries.each do |coutry|
        expect(dynamic_scaffold.list.title(coutry)).to eq coutry.name
      end
    end

    it 'should display the block\'s return value when passing the block.' do
      controller.class.send(:dynamic_scaffold, Country) do |c|
        c.list.title do |record|
          "Block with #{record.name}"
        end
      end
      countries = FactoryBot.create_list(:country, 3)
      get :index, params: { locale: :en }

      expect(dynamic_scaffold.list.title?).to be true
      countries.each do |coutry|
        expect(dynamic_scaffold.list.title(coutry)).to eq "Block with #{coutry.name}"
      end
    end
  end
end
