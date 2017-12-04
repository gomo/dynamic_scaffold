module DynamicScaffold
  class Util
    def initialize(config)
      @config = config
    end

    def reset_sequence(record_count)
      if @config.list.sorter_direction == :asc
        @sequence = 0
      elsif @config.list.sorter_direction == :desc
        @sequence = record_count - 1
      end
    end

    def next_sequence!
      val = @sequence
      if @config.list.sorter_direction == :asc
        @sequence += 1
      elsif @config.list.sorter_direction == :desc
        @sequence -= 1
      end
      val
    end

    def sorter_param(record)
      [*record.class.primary_key].map {|col| "#{col}:#{record[col]}" }.join(',')
    end
  end
end