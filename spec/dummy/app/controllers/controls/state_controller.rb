module Controls
  class StateController < ApplicationController
    include DynamicScaffold::Controller
    dynamic_scaffold State do |s|
    end
  end
end
