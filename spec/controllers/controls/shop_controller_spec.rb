require 'rails_helper'

RSpec.describe Controls::ShopController, type: :controller do
  describe 'Path Util' do
    it 'should be able to get path.' do
      get :index, params: { locale: :en, trailing_slash: true}
      util = assigns(:dynamic_scaffold_util)
  
      expect(util.path_for(:index)).to eq '/en/controls/master/shop/'
      expect(util.path_for(:new)).to eq '/en/controls/master/shop/new'
      expect(util.path_for(:sort)).to eq '/en/controls/master/shop/sort'
    end
  end
end
