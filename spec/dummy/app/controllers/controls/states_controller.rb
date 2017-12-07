module Controls
  class StatesController < ApplicationController
    include DynamicScaffold::Controller
    dynamic_scaffold State do |c|
    end
  end
end
