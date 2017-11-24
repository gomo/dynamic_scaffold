module Controls
  class CountryController < ApplicationController
    include DynamicScaffold::Controller
    dynamic_scaffold Country do |s|
      
    end
  end
end