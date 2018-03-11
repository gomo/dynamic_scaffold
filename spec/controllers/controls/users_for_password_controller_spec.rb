require 'rails_helper'

RSpec.describe Controls::UsersForPasswordController, type: :controller do
  describe 'Proxy' do
    render_views
    it 'should display the values of the attribute specifying the label and error message.' do
      user = FactoryBot.create(:user)
      get :edit, params: { locale: :en, id: user.id }
      body = response.body.delete!("\n").gsub!(/> +</, '><')
      expect(body).to match(
        /<label>FooBar<\/label><div class="clearfix"><input class="form-control" type="text" name="user\[password\]"/
      )

      patch :update, params: {
        locale: :en,
        id: user.id,
        user: {
          id: user.id,
          encrypted_password: ''
        }
      }
      body = response.body.delete!("\n").gsub!(/> +</, '><')
      expect(body).to match(
        /<\/svg> Encrypted password can&#39;t be blank<\/li>/
      )
    end
  end
end
