require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'Delete' do
    it 'should be able to delete.' do
      controller.class.send(:dynamic_scaffold, Country) {}
      country = FactoryBot.create(:country)
      delete :destroy, params: { locale: :en, id: country.id }

      expect(Country.find_by(id: country.id)).to be_nil
      expect(response).to redirect_to specs_path
    end
    it 'should display error if you delete record that can not be deleted with foreign key constraints' do
      controller.class.send(:dynamic_scaffold, Country) {}
      state = FactoryBot.create(:state)
      delete :destroy, params: {
        locale: :en,
        id: state.country.id
      }

      expect(Country.find_by(id: state.country.id)).not_to be_nil
      expect(flash['dynamic_scaffold_danger']).not_to be_nil
      expect(response).to redirect_to specs_path
    end
  end
end
