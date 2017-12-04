require 'rails_helper'

describe 'DynamicScaffold::Util' do
  context 'sequence' do
    it 'should be able to generate sequence number.' do
      config = DynamicScaffold::Config.new Country
      util = DynamicScaffold::Util.new(config, nil)
      # desc
      config.list.sorter sequence: :desc
      util.reset_sequence((1..5).to_a.size)
      expect(util.next_sequence!).to eq 4
      expect(util.next_sequence!).to eq 3
      expect(util.next_sequence!).to eq 2
      expect(util.next_sequence!).to eq 1
      expect(util.next_sequence!).to eq 0

      config.list.sorter sequence: :asc
      util.reset_sequence((1..5).to_a.size)
      expect(util.next_sequence!).to eq 0
      expect(util.next_sequence!).to eq 1
      expect(util.next_sequence!).to eq 2
      expect(util.next_sequence!).to eq 3
      expect(util.next_sequence!).to eq 4
    end
  end
end