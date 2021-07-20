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
    end
  end
end
