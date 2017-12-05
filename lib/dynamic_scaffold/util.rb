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

    def pkey_params(record)
      [*record.class.primary_key].each_with_object({}){|col, res| res[col] = record[col] }
    end

    def pkey_string(record)
      pkey_params(record).map{|k, v| "#{k}:#{v}"}.join(',')
    end

    def path_for(action, *args)
      route = Rails.application.routes.routes.find do |r|
        params = r.required_defaults
        params[:controller] == @controller.params[:controller] && (params[:action] == action.to_s && r.name)
      end

      raise "Missing #{@controller.params[:controller]}##{action}" if route.nil?

      @controller.send("#{route.name}_path", *args)
    end
  end
end
