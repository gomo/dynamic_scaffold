module DynamicScaffold
  module ActionView
    extend ActiveSupport::Concern

    included do
      include DynamicScaffold::ActionView::LocalInstanceMethods
    end

    module LocalInstanceMethods
      def dynamic_scaffold_icon(name)
        instance_exec name, &::Rails.application.config.dynamic_scaffold.icons
      end
    end
  end
end

::ActionView::Base.send :include, DynamicScaffold::ActionView
