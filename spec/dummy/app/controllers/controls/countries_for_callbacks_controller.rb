module Controls
  class CountriesForCallbacksController < BaseController
    include DynamicScaffold::Controller
    dynamic_scaffold Country do |c|
      c.list.sorter sequence: :desc

      %i[create update].each do |target|
        c.before_save target do |country|
          country.name = "executed #{target} before save!!"
        end
      end

      c.before_save :sort do |country, seq|
        country.name = "executed sort #{seq} before save!!"
      end

      c.before_save :destroy do |country|
        country.states.map(&:destroy)
      end
    end
  end
end
