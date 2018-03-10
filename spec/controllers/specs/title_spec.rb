require 'rails_helper'
RSpec.describe Controls::SpecsController, type: :controller do
  let :shop do
    FactoryBot.create(:shop)
  end

  def dynamic_scaffold
    self.controller.dynamic_scaffold
  end
  describe 'Title' do
    context 'Default' do
      it 'should get the title with the model name.' do
        self.controller.class.send(:dynamic_scaffold, Shop) {}
        get :index, params: { locale: :en }
        expect(dynamic_scaffold.title.current.name).to eq 'Shop'
        expect(dynamic_scaffold.title.current.action).to eq 'List'
        expect(dynamic_scaffold.title.current.full).to eq 'Shop List'

        get :new, params: { locale: :en }
        expect(dynamic_scaffold.title.current.name).to eq 'Shop'
        expect(dynamic_scaffold.title.current.action).to eq 'Create'
        expect(dynamic_scaffold.title.current.full).to eq 'Create Shop'

        get :edit, params: { locale: :en, id: shop.id }
        expect(dynamic_scaffold.title.current.name).to eq 'Shop'
        expect(dynamic_scaffold.title.current.action).to eq 'Edit'
        expect(dynamic_scaffold.title.current.full).to eq 'Edit Shop'
      end
    end

    context 'String' do
      it 'should get the title with the assigned name.' do
        self.controller.class.send(:dynamic_scaffold, Shop) do |config|
          config.title.name = 'FooBar'
        end
        get :index, params: { locale: :en }
        expect(dynamic_scaffold.title.current.name).to eq 'FooBar'
        expect(dynamic_scaffold.title.current.action).to eq 'List'
        expect(dynamic_scaffold.title.current.full).to eq 'FooBar List'

        get :new, params: { locale: :en }
        expect(dynamic_scaffold.title.current.name).to eq 'FooBar'
        expect(dynamic_scaffold.title.current.action).to eq 'Create'
        expect(dynamic_scaffold.title.current.full).to eq 'Create FooBar'

        get :edit, params: { locale: :en, id: shop.id }
        expect(dynamic_scaffold.title.current.name).to eq 'FooBar'
        expect(dynamic_scaffold.title.current.action).to eq 'Edit'
        expect(dynamic_scaffold.title.current.full).to eq 'Edit FooBar'
      end
    end

    context 'Block' do
      it 'should get the title with the return value of block.' do
        self.controller.class.send(:dynamic_scaffold, Shop) do |config|
          config.title.name { 'Block' }
        end
        get :index, params: { locale: :en }
        expect(dynamic_scaffold.title.current.name).to eq 'Block'
        expect(dynamic_scaffold.title.current.action).to eq 'List'
        expect(dynamic_scaffold.title.current.full).to eq 'Block List'

        get :new, params: { locale: :en }
        expect(dynamic_scaffold.title.current.name).to eq 'Block'
        expect(dynamic_scaffold.title.current.action).to eq 'Create'
        expect(dynamic_scaffold.title.current.full).to eq 'Create Block'

        get :edit, params: { locale: :en, id: shop.id }
        expect(dynamic_scaffold.title.current.name).to eq 'Block'
        expect(dynamic_scaffold.title.current.action).to eq 'Edit'
        expect(dynamic_scaffold.title.current.full).to eq 'Edit Block'
      end
    end
  end
end
