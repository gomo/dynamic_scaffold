require 'rails_helper'

RSpec.describe Controls::ShopsBlockController, type: :controller do
  describe 'block' do
    render_views
    it 'should display additional elements on the page.' do
      get :new, params: { locale: :en }
      body = response.body.delete!("\n").gsub!(/> +</, '><')
      expect(body).to match(/<label>Block<\/label>/)
      expect(body).to match(/<div><input class="form-control" type="text" name="shop\[block\]" \/><\/div>/)
      expect(body).to match(/<label>Block with label<\/label>/)
      expect(body).to match(/<input class="form-control" type="text" name="shop\[block_with_label\]" \/>/)
    end
  end
end
