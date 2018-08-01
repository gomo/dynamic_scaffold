module DynamicScaffold
  module Form
    module Item
      class Base # rubocop:disable Metrics/ClassLength
        class << self
          def create(config, type, *args, &block) # rubocop:disable Metrics/MethodLength
            case type
            when
              :check_box,
              :radio_button,
              :text_area,
              :text_field,
              :password_field,
              :hidden_field,
              :file_field,
              :color_field,
              :number_field,
              :telephone_field then
              item = Form::Item::SingleOption.new(config, type, *args)
            when
              :time_select,
              :date_select,
              :datetime_select,
              :collection_select,
              :grouped_collection_select then
              item = Form::Item::TwoOptions.new(config, type, *args)
            when
              :collection_check_boxes,
              :collection_radio_buttons then
              item = Form::Item::TwoOptionsWithBlock.new(config, type, *args)
            when
              :block then
              item = Form::Item::Block.new(config, type, *args, block)
            when
              :carrierwave_image then
              item = Form::Item::CarrierWaveImage.new(config, type, *args)
            when
              :globalize_fields then
              item = Form::Item::GlobalizeFields.new(config, type, *args)
            else
              raise DynamicScaffold::Error::InvalidParameter, "Unknown form item type #{type}"
            end

            item
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

        def label(label = nil, &block)
          if block_given?
            raise Error::InvalidParameter, 'Only the block type accepts block.' unless type? :block
            @block = block
          end
          if label
            @label = label
            self
          else
            return @label if @label
            @config.model.human_attribute_name @name
          end
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

        def default(value = nil)
          return @default if value.nil?
          @default = value
        end

        def insert(position, &block)
          if block_given?
            @inserts[position] << block
            self
          else
            @inserts[position]
          end
        end

        def errors(record)
          msg = record.errors.full_messages_for(proxy_field.name)
          rel = @config.model.reflect_on_all_associations.find {|r| r.foreign_key.to_s == name.to_s }
          msg.concat(record.errors.full_messages_for(rel.name)) if rel.present?
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
