module DynamicScaffold
  module Helper
    extend ActiveSupport::Concern

    included do
      include DynamicScaffold::Helper::LocalInstanceMethods
    end

    module LocalInstanceMethods
      def dynamic_scaffold_config
        ::Rails.application.config.dynamic_scaffold
      end
    end
  end
end

ActionView::Base.send :include, DynamicScaffold::Helper
