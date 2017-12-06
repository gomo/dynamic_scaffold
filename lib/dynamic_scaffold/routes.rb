module DynamicScaffold
  module Routes
    extend ActiveSupport::Concern

    included do
      include DynamicScaffold::Routes::LocalInstanceMethods
    end

    module LocalInstanceMethods
      def dynamic_scaffold_for(*resources)
        options = resources.extract_options!
        path = resources[0]
        controller = resources[1] ? resources[1] : resources[0]
        get(path, { to: "#{controller}#index" }.merge(options).merge(trailing_slash: true))
        post(path, { to: "#{controller}#create" }.merge(options).merge(trailing_slash: true))
        get("#{path}/new", { to: "#{controller}#new" }.merge(options))
        get("#{path}/edit", { to: "#{controller}#edit" }.merge(options))
        patch("#{path}/sort_or_destroy", { to: "#{controller}#sort_or_destroy" }.merge(options))
        patch("#{path}/update", { to: "#{controller}#update" }.merge(options))
      end
    end
  end
end

::ActionDispatch::Routing::Mapper.send :include, DynamicScaffold::Routes
