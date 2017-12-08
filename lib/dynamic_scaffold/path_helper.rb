module DynamicScaffold
  module PathHelper
    extend ActiveSupport::Concern

    included do
      include DynamicScaffold::PathHelper::LocalInstanceMethods
    end

    module LocalInstanceMethods
      def dynamic_scaffold_path(action, options = {})
      route = Rails.application.routes.routes.find do |r|
        route_params = r.required_defaults
        route_params[:controller] == params[:controller] && (route_params[:action] == action.to_s && r.name)
      end

      if route.nil?
        raise DynamicScaffold::Error::RouteNotFound,
          "Missing controller#action #{params[:controller]}##{action}"
      end

      public_send("#{route.name}_path", options)
    end
    end
  end
end

::ActionView::Base.send :include, DynamicScaffold::PathHelper
::ActionController::Base.send :include, DynamicScaffold::PathHelper
