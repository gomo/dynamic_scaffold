require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  describe 'Insert After' do
    render_views
    it 'should insert a tag after the specified element.' do
      controller.class.send(:dynamic_scaffold, Country) do |c|
        c.form.item(:text_field, :id).insert(:after) do |rec|
          tag.div 'foobar'
        end
      end

      get :new, params: { locale: :en }

      expect(response.body).to match(
        /<input class="form-control" type="text" name="country\[id\]" \/>[\s\S]*?<div>foobar<\/div>/
      )
    end
  end
end
