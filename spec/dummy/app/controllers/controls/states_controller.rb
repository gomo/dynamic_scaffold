module Controls
  class StatesController < BaseController
    include DynamicScaffold::Controller
    dynamic_scaffold State do |c|
    end
  end
end
