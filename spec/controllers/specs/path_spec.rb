# frozen_string_literal: true

require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'Path' do
    it 'should be able to get path.' do
      controller.class.send(:dynamic_scaffold, Country) {}
      get :index, params: { locale: :en }
      expect(controller.send(:dynamic_scaffold_path, :index)).to eq '/en/specs'
      expect(controller.send(:dynamic_scaffold_path, :new)).to eq '/en/specs/new'
      expect(controller.send(:dynamic_scaffold_path, :edit, id: 1)).to eq '/en/specs/1/edit'
      expect(controller.send(:dynamic_scaffold_path, :update, id: 1)).to eq '/en/specs/1'
      expect(controller.send(:dynamic_scaffold_path, :sort)).to eq '/en/specs/sort'
    end
  end
end
