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
            as: "#{as_base}_index",
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
            as: "new_#{as_base}",
            to: "#{controller}#new"
          )
        )
        get(
          "#{path}/edit",
          options.merge(
            as: "edit_#{as_base}",
            to: "#{controller}#edit",
          )
        )
        patch(
          path,
          options.merge(
            as: as_base,
            to: "#{controller}#update"
          )
        )
        patch(
          "#{path}/sort_or_destroy",
          options.merge(
            as: "sort_or_destroy_#{as_base}",
            to: "#{controller}#sort_or_destroy"
          )
        )
      end
    end
  end
end

::ActionDispatch::Routing::Mapper.send :include, DynamicScaffold::Routes
