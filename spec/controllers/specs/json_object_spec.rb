require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'html' do
    render_views
    it 'should display additional elements on the page.' do
      controller.class.send(:dynamic_scaffold, Shop) do |c|
        c.form.item :json_object, :data do |form|
          form.item(:text_field, :foobar)
        end
      end

      get :new, params: { locale: :en }
      doc = Nokogiri::HTML(response.body)

      # wrapper
      wrappers = doc.css('[data-name="shops_data"]')
      expect(wrappers.length).to eq 1
      wrapper = wrappers.first

      # form-group
      groups = wrapper.css('[data-name="shops_data_foobar"]')
      expect(groups.length).to eq 1
      group = groups.first

      expect(group.css('.ds-label').first.text).to eq 'Foobar'
      expect(group.css('input[type="text"][name="shop[data][foobar]"]').length).to eq 1
    end
  end
end