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
        controller = options[:controller] ? options[:controller] : resources[0]
        as_base = options[:as] ? options[:as] : controller.gsub('/', '_')
        get(path, { to: "#{controller}#index" }.merge(options).merge(as: as_base))
        post(path, { to: "#{controller}#create" }.merge(options))
        get("#{path}/new", { to: "#{controller}#new" }.merge(options).merge(as: "#{as_base}_new"))
        get("#{path}/edit", { to: "#{controller}#edit" }.merge(options).merge(as: "#{as_base}_edit"))
        patch("#{path}/sort_or_destroy", { to: "#{controller}#sort_or_destroy" }.merge(options).merge(as: "#{as_base}_sort_or_destroy"))
        patch("#{path}/update", { to: "#{controller}#update" }.merge(options).merge(as: "#{as_base}_update"))
      end
    end
  end
end

::ActionDispatch::Routing::Mapper.send :include, DynamicScaffold::Routes
