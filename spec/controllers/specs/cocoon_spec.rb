require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'cocoon' do
    it 'should create items specified.' do
      controller.class.send(:dynamic_scaffold, Shop) do |c|
        c.form.item :cocoon, :shop_memos do |form|
          form.item(:text_field, :title)
          form.item(:text_area, :body)
        end
      end

      get :new, params: { locale: :en }

      cocoon = dynamic_scaffold.form.items.find{|e| e.type? :cocoon }

      expect(cocoon.form.items.length).to eq 2
      expect(cocoon.form.items[0].type?(:text_field)).to be true
      expect(cocoon.form.items[0].name).to eq :title
      expect(cocoon.form.items[1].type?(:text_area)).to be true
      expect(cocoon.form.items[1].name).to eq :body
    end
  end
end
