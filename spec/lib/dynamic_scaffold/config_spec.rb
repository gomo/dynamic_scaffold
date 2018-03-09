require 'rails_helper'

class DynamicScaffoldSpecError < StandardError; end

RSpec.describe ApplicationHelper, type: :helper do
  describe 'DynamicScaffold::Config' do
    context '#title' do
      it 'should get according to the action.' do
        config = DynamicScaffold::Config.new(Shop, nil)
        expect(config.title.index(helper)).to eq 'Shop List'
        expect(config.title.edit(helper)).to eq 'Edit Shop'
        expect(config.title.update(helper)).to eq 'Edit Shop'
        expect(config.title.new(helper)).to eq 'Create Shop'
        expect(config.title.create(helper)).to eq 'Create Shop'

        config = DynamicScaffold::Config.new(Shop, nil)
        config.title.name = 'foobar'
        expect(config.title.index(helper)).to eq 'foobar List'
        expect(config.title.edit(helper)).to eq 'Edit foobar'
        expect(config.title.update(helper)).to eq 'Edit foobar'
        expect(config.title.new(helper)).to eq 'Create foobar'
        expect(config.title.create(helper)).to eq 'Create foobar'

        config = DynamicScaffold::Config.new(Shop, nil)
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
