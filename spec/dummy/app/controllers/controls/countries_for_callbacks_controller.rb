module Controls
  class CountriesForCallbacksController < BaseController
    include DynamicScaffold::Controller
    dynamic_scaffold Country do |c|
      %i[create update each_sort].each do |target|
        c.before_save target do |country|
          country.name = "executed #{target} before save!!"
        end
      end

      c.before_save :destroy do |country|
        country.states.destroy
      end

      c.before_save :sort do |countries|
        countries.each do |country|
          country.name = 'executed sort before save!!'
        end
      end
    end
  end
end
