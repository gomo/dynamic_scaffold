require 'rails_helper'

class DynamicScaffoldSpecError < StandardError; end

RSpec.describe ApplicationHelper, type: :helper do
  describe 'DynamicScaffold::Config' do
    context '#form.before_save' do
      it 'should be able to execute a block with a target specified.' do
        config = DynamicScaffold::Config.new Country
        config.form.before_save :create do |record, _prev|
          raise DynamicScaffoldSpecError, record.name
        end

        controller = Controls::ShopsController.new
        country = FactoryBot.create(:country)
        country.name = 'block'

        %i[before_save_update before_save_destroy].each do |target|
          expect do
            config.form.callback.call(target, controller, country, country.attributes)
          end.not_to raise_error
        end

        [:before_save_create].each do |target|
          expect do
            config.form.callback.call(target, controller, country, country.attributes)
          end.to raise_error(DynamicScaffoldSpecError, 'block')
        end
      end
      it 'should be able to execute a block with multiple targets specified.' do
        config = DynamicScaffold::Config.new Country
        config.form.before_save :create, :update do |record, _prev|
          raise DynamicScaffoldSpecError, record.name
        end

        controller = Controls::ShopsController.new
        country = FactoryBot.create(:country)
        country.name = 'block'

        %i[before_save_destroy].each do |target|
          expect do
            config.form.callback.call(target, controller, country, country.attributes)
          end.not_to raise_error
        end

        %i[before_save_create before_save_update].each do |target|
          expect do
            config.form.callback.call(target, controller, country, country.attributes)
          end.to raise_error(DynamicScaffoldSpecError, 'block')
        end
      end
    end
    context '#list.before_save' do
      it 'should be able to execute a block with a target specified.' do
        config = DynamicScaffold::Config.new Country
        config.list.before_save :sort do |record, _prev|
          raise DynamicScaffoldSpecError, record.name
        end

        controller = Controls::ShopsController.new
        country = FactoryBot.create(:country)
        country.name = 'block'

        expect do
          config.list.callback.call(:before_save_sort, controller, country, country.attributes)
        end.to raise_error(DynamicScaffoldSpecError, 'block')
      end
    end
    context '#list.before_fetch' do
      it 'should be able to execute a block with a target specified.' do
        config = DynamicScaffold::Config.new Shop
        config.list.before_fetch do |query|
          raise DynamicScaffoldSpecError, query.to_sql
        end

        controller = Controls::ShopsController.new

        expect do
          config.list.callback.call(:before_fetch, controller, Shop.all)
        end.to raise_error(DynamicScaffoldSpecError, 'SELECT "shops".* FROM "shops"')
      end
    end
    context '#title' do
      it 'should get according to the action.' do
        config = DynamicScaffold::Config.new Shop
        expect(config.title.index(helper)).to eq 'Shop List'
        expect(config.title.edit(helper)).to eq 'Edit Shop'
        expect(config.title.update(helper)).to eq 'Edit Shop'
        expect(config.title.new(helper)).to eq 'Create Shop'
        expect(config.title.create(helper)).to eq 'Create Shop'

        config = DynamicScaffold::Config.new Shop
        config.title.name = 'foobar'
        expect(config.title.index(helper)).to eq 'foobar List'
        expect(config.title.edit(helper)).to eq 'Edit foobar'
        expect(config.title.update(helper)).to eq 'Edit foobar'
        expect(config.title.new(helper)).to eq 'Create foobar'
        expect(config.title.create(helper)).to eq 'Create foobar'

        config = DynamicScaffold::Config.new Shop
        config.title.name do |_params|
          'Block'
        end
        expect(config.title.index(helper)).to eq 'Block List'
        expect(config.title.edit(helper)).to eq 'Edit Block'
        expect(config.title.update(helper)).to eq 'Edit Block'
        expect(config.title.new(helper)).to eq 'Create Block'
        expect(config.title.create(helper)).to eq 'Create Block'
      end
    end
  end
end
