module DynamicScaffold
  module Form
    module Field
      class Base
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
          @multiple = false
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

        def strong_parameter
          return { @name => [] } if @multiple
          @name
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
          return view.instance_exec(&@if_block) if @if_block
          return !view.instance_exec(&@unless_block) if @unless_block
        end

        def error_proxy(attribute_name)
          @error_proxy = attribute_name
          self
        end

        def error_name
          return @error_proxy if @error_proxy
          @name
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
