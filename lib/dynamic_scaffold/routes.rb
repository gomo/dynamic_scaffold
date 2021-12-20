# frozen_string_literal: true

module DynamicScaffold
  module Routes
    extend ActiveSupport::Concern

    included do
      include DynamicScaffold::Routes::LocalInstanceMethods
    end

    module LocalInstanceMethods
      def dynamic_scaffold_for(*resources)
        options = resources.extract_options!.dup
        path = resources[0]
        resources path, options.merge(except: %i[show]) do
          collection do
            patch :sort, controller: options[:controller]
          end
        end
      end
    end
  end
end

::ActionDispatch::Routing::Mapper.include DynamicScaffold::Routes
