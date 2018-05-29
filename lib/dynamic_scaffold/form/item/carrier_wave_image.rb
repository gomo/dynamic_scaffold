module DynamicScaffold
  module Form
    module Item
      class CarrierWaveImage < Base
        attr_reader :options
        def initialize(config, type, name, options = {})
          super(config, type, name, {})
          @options = options
          @options[:removable] = true if @options[:removable].nil?
        end

        def preview_image_style
          max_size = @options[:preview_max_size]
          return '' unless max_size

          ''.tap do |s|
            s << "max-width: #{max_size[:width]};" if max_size[:width]
            s << "max-height: #{max_size[:height]};" if max_size[:height]
          end
        end

        def render(_view, _form, classnames = nil)
          html_attributes = build_html_attributes(classnames)
          yield(html_attributes)
        end

        def strong_parameter
          @options[:removable] ? [@name, "remove_#{@name}"]  : @name
        end
      end
    end
  end
end
