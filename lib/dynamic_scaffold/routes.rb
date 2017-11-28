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
        get(path, {to: "#{resources[0]}#index"}.merge(options).merge(trailing_slash: true))
        get("#{path}/new", {to: "#{resources[0]}#new"}.merge(options))
      end
    end
  end
end

::ActionDispatch::Routing::Mapper.send :include, DynamicScaffold::Routes
