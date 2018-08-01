module DynamicScaffold
  module Form
    module Item
      class GlobalizeFields < Base
        attr_reader :locales

        def initialize(config, type, locales, options = {})
          super(config, type, :translations_attributes, options)
          @locales = locales
        end

        def for(type, *args, &block)
          @item = Form::Item::Base.create(@config, type, *args, &block)
        end

        def render(view, form, classnames = nil)
          @item.render(view, form, classnames)
        end

        def proxy_field
          @item.proxy_field
        end

        def strong_parameter
          { translations_attributes: [:id, :locale, @item.name] }
        end

        def extract_parameters(permitting)
          trans = permitting.find{|item| item.is_a?(Hash) && item.key?(:translations_attributes) }
          if trans.nil?
            permitting << { translations_attributes: [:id, :locale, @item.name] }
          else
            trans[:translations_attributes] << @item.name
          end
        end

        def lang_attributes(classnames = nil)
          build_html_attributes(classnames)
        end
      end
    end
  end
end
