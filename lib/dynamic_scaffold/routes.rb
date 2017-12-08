module DynamicScaffold
  module Routes
    extend ActiveSupport::Concern

    included do
      include DynamicScaffold::Routes::LocalInstanceMethods
    end

    module LocalInstanceMethods
      def dynamic_scaffold_for(*resources) # rubocop:disable Metrics/MethodLength
        options = resources.extract_options!
        path = resources[0]
        controller = options[:controller] ? options[:controller] : resources[0]
        as_base = options[:as] ? options[:as] : controller.tr('/', '_')

        get(
          path,
          options.merge(
            as: as_base,
            to: "#{controller}#index"
          )
        )
        post(
          path,
          options.merge(
            as: nil,
            to: "#{controller}#create"
          )
        )
        get(
          "#{path}/new",
          options.merge(
            as: "#{as_base}_new",
            to: "#{controller}#new"
          )
        )
        get(
          "#{path}/edit",
          options.merge(
            as: "#{as_base}_edit",
            to: "#{controller}#edit"
          )
        )
        patch(
          "#{path}/sort_or_destroy",
          options.merge(
            as: "#{as_base}_sort_or_destroy",
            to: "#{controller}#sort_or_destroy"
          )
        )
        patch(
          "#{path}/update",
          options.merge(
            as: "#{as_base}_update",
            to: "#{controller}#update"
          )
        )
      end
    end
  end
end

::ActionDispatch::Routing::Mapper.send :include, DynamicScaffold::Routes
