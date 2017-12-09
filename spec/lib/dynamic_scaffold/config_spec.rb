require 'rails_helper'

class DynamicScaffoldSpecError < StandardError; end

describe 'DynamicScaffold::Config' do
  context '#before_save' do
    it 'should be able to execute a block with a target specified.' do
      config = DynamicScaffold::Config.new Country
      config.before_save :create do |record|
        raise DynamicScaffoldSpecError, record.name
      end

      controller = Controls::ShopsController.new
      country = FactoryBot.create(:country)
      country.name = 'block'

      %i[update destroy sort].each do |target|
        expect do
          config.call_before_save(target, controller, country)
        end.not_to raise_error
      end

      [:create].each do |_target|
        expect do
          config.call_before_save(:create, controller, country)
        end.to raise_error(DynamicScaffoldSpecError, 'block')
      end
    end
    it 'should be able to execute a block with multiple targets specified.' do
      config = DynamicScaffold::Config.new Country
      config.before_save :create, :update, :destroy do |record|
        raise DynamicScaffoldSpecError, record.name
      end

      controller = Controls::ShopsController.new
      country = FactoryBot.create(:country)
      country.name = 'block'

      %i[sort].each do |target|
        expect do
          config.call_before_save(target, controller, country)
        end.not_to raise_error
      end

      %i[create update destroy].each do |_target|
        expect do
          config.call_before_save(:create, controller, country)
        end.to raise_error(DynamicScaffoldSpecError, 'block')
      end
    end
    it 'should be able to execute a controller method with a target specified.' do
      config = DynamicScaffold::Config.new Country
      config.before_save :before_save_scaffold, :create

      controller = Controls::ShopsController.new
      country = FactoryBot.create(:country)
      country.name = 'controller'

      %i[update destroy sort].each do |target|
        expect do
          config.call_before_save(target, controller, country)
        end.not_to raise_error
      end

      [:create].each do |_target|
        expect do
          config.call_before_save(:create, controller, country)
        end.to raise_error(DynamicScaffoldSpecError, 'controller')
      end
    end
    it 'should be able to execute a controller method with muiltiple targets specified.' do
      config = DynamicScaffold::Config.new Country
      config.before_save :before_save_scaffold, :create, :update, :sort

      controller = Controls::ShopsController.new
      country = FactoryBot.create(:country)
      country.name = 'controller'

      %i[destroy].each do |target|
        expect do
          config.call_before_save(target, controller, country)
        end.not_to raise_error
      end

      %i[create update sort].each do |_target|
        expect do
          config.call_before_save(:create, controller, country)
        end.to raise_error(DynamicScaffoldSpecError, 'controller')
      end
    end
  end
end
