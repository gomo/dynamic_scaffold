module Controls
  class CountriesForCallbacksController < BaseController
    include DynamicScaffold::Controller
    dynamic_scaffold Country do |c|
      c.list.sorter sequence: :desc

      %i[create update].each do |target|
        c.form.before_save target do |country, _prev|
          country.name = "executed #{target} before save!!"
        end
      end

      c.list.before_save :sort do |country, _prev|
        country.name = "executed sort #{country.sequence} before save!!"
      end

      c.form.before_save :destroy do |country, _prev|
        country.states.map(&:destroy)
      end
    end
  end
end
