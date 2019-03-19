module DynamicScaffold
  module Form
    module Item
      class Base # rubocop:disable Metrics/ClassLength
        ITEM_TYPES = {
          check_box: Form::Item::SingleOption,
          radio_button: Form::Item::SingleOption,
          text_area: Form::Item::SingleOption,
          text_field: Form::Item::SingleOption,
          password_field: Form::Item::SingleOption,
          hidden_field: Form::Item::SingleOption,
          file_field: Form::Item::SingleOption,
          color_field: Form::Item::SingleOption,
          number_field: Form::Item::SingleOption,
          telephone_field: Form::Item::SingleOption,

          time_select: Form::Item::TwoOptions,
          date_select: Form::Item::TwoOptions,
          datetime_select: Form::Item::TwoOptions,
          collection_select: Form::Item::TwoOptions,
          grouped_collection_select: Form::Item::TwoOptions,

          collection_check_boxes: Form::Item::TwoOptionsWithBlock,
          collection_radio_buttons: Form::Item::TwoOptionsWithBlock,

          block: Form::Item::Block,

          carrierwave_image: Form::Item::CarrierWaveImage,

          globalize_fields: Form::Item::GlobalizeFields,

          cocoon: Form::Item::Cocoon
        }.freeze

        class << self
          def create(config, type, *args, &block)
            if ITEM_TYPES[type].nil?
              raise(
                DynamicScaffold::Error::InvalidParameter,
                "Unknown form item type #{type}. supported: #{ITEM_TYPES.keys.join(', ')}"
              )
            end

            ITEM_TYPES[type].new(config, type, *args, &block)
          end
        end

        attr_reader :name
        def initialize(config, type, name, html_attributes = {})
          @config = config
          @name = name
          @type = type
          @html_attributes = html_attributes
          classnames = @html_attributes.delete(:class)
          @classnames_list = []
          @classnames_list.push(classnames) if classnames
          @notes = []
          @multiple = type == :collection_check_boxes || html_attributes[:multiple]
          @inserts = { before: [], after: [] }
          @label_attributes = {}
          @label_block = nil
        end

        def notes?
          !@notes.empty?
        end

        def note(&block)
          @notes << block if block_given?
          self
        end

        def render_notes(record, view)
          htmls = @notes.map do |note|
            view.instance_exec(record, &note)
          end
          view.safe_join(htmls)
        end

        def type?(type)
          @type == type
        end

        def label?
          !@label.nil?
        end

        def label(label = nil, html_attributes = {}, &block)
          if label
            @label = label
            @label_attributes = html_attributes
            self
          elsif block_given?
            @label_block = block
          else
            return @label if @label

            @config.model.human_attribute_name @name
          end
        end

        def render_label(view)
          return view.instance_exec(proxy_field.label, &@label_block) if @label_block.present?

          view.tag.label(proxy_field.label, @label_attributes)
        end

        def extract_parameters(permitting)
          if @multiple
            permitting << { @name => [] }
          else
            permitting << @name
          end
        end

        def if(&block)
          @if_block = block
          self
        end

        def unless(&block)
          @unless_block = block
          self
        end

        def needs_rendering?(view)
          return true unless @if_block || @unless_block
          return view.instance_exec(view.controller.params, &@if_block) if @if_block
          return !view.instance_exec(view.controller.params, &@unless_block) if @unless_block
        end

        def proxy(attribute_name)
          @proxy = attribute_name
          self
        end

        def proxy_field
          return self unless @proxy

          proxy_target = @config.form.items.select {|f| f.name == @proxy }
          raise DynamicScaffold::Error::InvalidParameter, "Missing proxy target element: #{@proxy}" if proxy_target.empty?

          proxy_target.first
        end

        def default(value = nil, &block)
          if block_given?
            @default = block
          else
            @default = value
          end
        end

        def default_value(view)
          return view.instance_exec(&@default) if @default.is_a? Proc

          @default
        end

        def insert(position, &block)
          if block_given?
            @inserts[position] << block
            self
          else
            @inserts[position]
          end
        end

        def errors(form)
          msg = form.object.errors.full_messages_for(proxy_field.name)
          rel = @config.model.reflect_on_all_associations.find {|r| r.foreign_key.to_s == name.to_s }
          msg.concat(form.object.errors.full_messages_for(rel.name)) if rel.present?
          msg
        end

        protected

          def build_html_attributes(classnames)
            classnames_list = @classnames_list
            classnames_list = [*classnames_list, classnames] if classnames
            options = @html_attributes.dup
            options[:class] = classnames_list.join(' ') unless classnames_list.empty?
            options
          end
      end
    end
  end
end
