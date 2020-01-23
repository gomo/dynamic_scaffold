module DynamicScaffold
  module Form
    module Item
      class Base # rubocop:disable Metrics/ClassLength
        class << self
          def create(config, type, *args, &block)
            if Form::Item::Type::LIST[type].nil?
              raise(
                DynamicScaffold::Error::InvalidParameter,
                "Unknown form item type #{type}. supported: #{Form::Item::Type::LIST.keys.join(', ')}"
              )
            end

            Form::Item::Type::LIST[type].new(config, type, *args, &block)
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
            view.capture do
              view.instance_exec(record, &note)
            end
          end
          view.safe_join(htmls)
        end

        def type?(*args)
          args.include?(@type)
        end

        def label?
          !@label.nil?
        end

        def label(*args, &block)
          return @label || @config.model.human_attribute_name(@name) if args.empty? && block.nil?

          @label_attributes = args.extract_options!
          @label = args.first unless args.empty?
          @label_block = block if block_given?

          self
        end

        def render_label(view, depth)
          label_attrs = @label_attributes.dup
          if label_attrs[:class].present?
            label_attrs[:class] = "ds-label #{label_attrs[:class]}"
          else
            label_attrs[:class] = 'ds-label'
          end

          if @label_block.present?
            label = view.instance_exec(
              proxy_field.label,
              depth,
              label_attrs,
              &@label_block
            )
            return label unless label.nil?
          end

          # if DynamicScaffold.config.form.label.present?
          #   label = view.instance_exec(
          #     proxy_field.label,
          #     depth,
          #     label_attrs,
          #     &DynamicScaffold.config.form.label
          #   )
          #   return label unless label.nil?
          # end

          view.tag.label(proxy_field.label, label_attrs)
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
          self
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
