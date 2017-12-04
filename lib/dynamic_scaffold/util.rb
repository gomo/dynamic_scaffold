module DynamicScaffold
  class Util
    def initialize(config, controller)
      @config = config
      @controller = controller
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

    def path_for(action, *args)
      route = Rails.application.routes.routes.find do |route|
        params = route.required_defaults
        params[:controller] == @controller.params[:controller] && (params[:action] == action.to_s && route.name)
      end

      @controller.instance_exec do
        eval "#{route.name}_path"
      end
    end
  end
end