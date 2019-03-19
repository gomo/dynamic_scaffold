require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'Form' do
    render_views
    it 'should display additional elements on the page.' do
      controller.class.send(:dynamic_scaffold, Shop) do |c|
        c.form.item :block, :block do |form, field|
          content_tag :div do
            form.text_field field.name, class: 'form-control'
          end
        end
        c.form.item(:block, :block_with_label) do |form, field|
          form.text_field field.name, class: 'form-control'
        end.label 'Block with label'
      end
      get :new, params: { locale: :en }
      body = response.body.delete!("\n").gsub!(/> +</, '><')
      expect(body).to match(/<label>Block<\/label>/)
      expect(body).to match(/<div><input class="form-control" type="text" name="shop\[block\]" \/><\/div>/)
      expect(body).to match(/<label>Block with label<\/label>/)
      expect(body).to match(/<input class="form-control" type="text" name="shop\[block_with_label\]" \/>/)
    end
  end
end
