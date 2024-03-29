# frozen_string_literal: true

module DynamicScaffold
  module Form
    module Item
      class GlobalizeFields < Base
        attr_reader :locales
        delegate :proxy_field, :notes?, :render_notes, :render, to: :@item

        def initialize(config, type, locales, options = {})
          super(config, type, :translations_attributes, options)
          @locales = locales
        end

        def for(type, *args, &block)
          @item = Form::Item::Base.create(@config, type, *args, &block)
        end

        def strong_parameter
          { translations_attributes: [:id, :locale, @item.name] }
        end

        def extract_parameters(permitting)
          trans = permitting.find {|item| item.is_a?(Hash) && item.key?(:translations_attributes) }
          if trans.nil?
            permitting << { translations_attributes: [:id, :locale, @item.name] }
          else
            trans[:translations_attributes] << @item.name
          end
        end

        def lang_attributes(classnames = nil)
          build_html_attributes(classnames)
        end

        def locale_errors(locale, form)
          form.object.errors.full_messages_for("#{@item.proxy_field.name}_#{locale}")
        end
      end
    end
  end
end
