require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'Vars' do
    it 'should get the same usec and controller_name on the request.' do
      controller.class.send(:dynamic_scaffold, Country) do |c|
        c.vars :request_time do
          Time.zone.now
        end

        c.vars :controller_name do
          params['controller']
        end
      end

      get :index, params: { locale: :en }
      first_time = controller.dynamic_scaffold.vars.request_time
      expect(first_time).not_to be nil
      expect(first_time).to eq controller.dynamic_scaffold.vars.request_time
      expect(controller.dynamic_scaffold.vars.controller_name).to eq 'specs'

      get :index, params: { locale: :en }
      second_time = controller.dynamic_scaffold.vars.request_time
      expect(second_time).not_to be nil
      expect(second_time).not_to eq first_time

      get :new, params: { locale: :en }
      expect(controller.dynamic_scaffold.vars.controller_name).not_to be nil
      expect(controller.dynamic_scaffold.vars.controller_name).to eq 'specs'

      country = FactoryBot.create(:country)
      get :edit, params: { locale: :en, id: country.id }
      expect(controller.dynamic_scaffold.vars.controller_name).not_to be nil
      expect(controller.dynamic_scaffold.vars.controller_name).to eq 'specs'
    end
  end
end
