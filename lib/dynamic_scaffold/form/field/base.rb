module DynamicScaffold
  module Form
    module Field
      class Base
        attr_reader :name
        def initialize(manager, type, name, html_attributes = {})
          @dynamic_scaffold = manager
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

        def label(label = nil)
          if label
            @label = label
            self
          else
            return @label if @label
            @dynamic_scaffold.model.human_attribute_name @name
          end
        end

        def strong_parameter
          return { @name => [] } if @multiple
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
