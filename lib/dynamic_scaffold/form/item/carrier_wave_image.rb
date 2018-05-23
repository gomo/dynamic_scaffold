module DynamicScaffold
  module Form
    module Item
      class CarrierWaveImage < Base
        def initialize(config, type, name, options)
          super(config, type, name, {})
          @options = options
        end

        def preview_image_style
          max_size = @options[:preview_max_size]
          return '' unless max_size

          ''.tap do |s|
            s << "max-width: #{max_size[:width]};" if max_size[:width]
            s << "max-height: #{max_size[:height]};" if max_size[:height]
          end
        end

        def render(view, form, classnames = nil)
          html_attributes = build_html_attributes(classnames)
          yield(html_attributes)
        end

        def strong_parameter
          [@name, "remove_#{@name}"]
        end
      end
    end
  end
end
