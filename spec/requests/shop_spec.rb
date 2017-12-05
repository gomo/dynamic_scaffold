require 'rails_helper'

RSpec.describe 'Shop', type: :request do
  describe 'Create' do
    it 'should be able to create.' do
      get '/en/controls/master/shop/'
      util = assigns(:dynamic_scaffold_util)
      
      post '/en/controls/master/shop/', params: {locale: :en, trailing_slash: true, shop: {name: ''}}
      expect(response).to render_template(:new)
    end
  end
end