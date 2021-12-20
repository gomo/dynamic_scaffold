# frozen_string_literal: true

require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  let :shop do
    FactoryBot.create(:shop)
  end

  delegate :dynamic_scaffold, to: :controller
  describe 'Title' do
    context 'Default' do
      it 'should get the title with the model name.' do
        controller.class.send(:dynamic_scaffold, Shop) {}
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
        controller.class.send(:dynamic_scaffold, Shop) do |config|
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
        controller.class.send(:dynamic_scaffold, Shop) do |config|
          config.title.name { "#{params['action']} Block" }
        end
        get :index, params: { locale: :en }
        expect(dynamic_scaffold.title.current.name).to eq 'index Block'
        expect(dynamic_scaffold.title.current.action).to eq 'List'
        expect(dynamic_scaffold.title.current.full).to eq 'index Block List'

        get :new, params: { locale: :en }
        expect(dynamic_scaffold.title.current.name).to eq 'new Block'
        expect(dynamic_scaffold.title.current.action).to eq 'Create'
        expect(dynamic_scaffold.title.current.full).to eq 'Create new Block'

        get :edit, params: { locale: :en, id: shop.id }
        expect(dynamic_scaffold.title.current.name).to eq 'edit Block'
        expect(dynamic_scaffold.title.current.action).to eq 'Edit'
        expect(dynamic_scaffold.title.current.full).to eq 'Edit edit Block'
      end
    end

    context 'Another actions' do
      it 'should can get the title by specifying action.' do
        controller.class.send(:dynamic_scaffold, Shop) {}
        get :index, params: { locale: :en }
        expect(dynamic_scaffold.title.index.action).to eq 'List'
        expect(dynamic_scaffold.title.index.full).to eq 'Shop List'

        expect(dynamic_scaffold.title.edit.action).to eq 'Edit'
        expect(dynamic_scaffold.title.edit.full).to eq 'Edit Shop'

        expect(dynamic_scaffold.title.new.action).to eq 'Create'
        expect(dynamic_scaffold.title.new.full).to eq 'Create Shop'
      end
    end
  end
end
