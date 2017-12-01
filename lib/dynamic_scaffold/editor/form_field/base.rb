module DynamicScaffold
  module Editor
    module FormField
      class Base
        def initialize(type, name, html_attributes = {})
          @name = name
          @type = type
          @html_attributes = html_attributes
          classnames = @html_attributes.delete(:class)
          @classnames_list = []
          @classnames_list.push(classnames) if classnames
          @notes = []
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

        def label(arg)
          if arg.is_a? String
            @label = arg
            self
          else
            return @label if @label
            # TODO Stop passing form to label. (Make FormField and List::Item have manager reference)
            arg.object.class.human_attribute_name @name
          end
        end

        def label?
          !@label.nil?
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
