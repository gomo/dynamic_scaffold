module Controls
  class CountriesForCallbacksController < BaseController
    include DynamicScaffold::Controller
    dynamic_scaffold Country do |c|
      c.list.sorter sequence: :desc

      %i[create update].each do |target|
        c.form.before_save target do |country, prev|
          country.name = "executed #{target} before save!! [#{prev['name'] || 'empty'}:#{country.name}]"
        end
      end

      c.list.before_save :sort do |country, prev|
        country.name = "executed sort before save!! [#{prev['sequence']}:#{country.sequence}]"
      end

      c.form.before_save :destroy do |country, prev|
        raise 'prev_attribute should be empty.' unless prev.empty?
        country.states.map(&:destroy)
      end
    end
  end
end
