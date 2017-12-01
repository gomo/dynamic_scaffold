module DynamicScaffold
  module Editor
    module FormField
      class Base
        def initialize(type, name, label, html_attributes = {})
          @name = name
          @type = type
          @label = label
          @html_attributes = html_attributes
          classnames = @html_attributes.delete(:class)
          @classnames_list = []
          @classnames_list.push(classnames) if classnames
        end

        def description(&block)
          @description = block if block_given?
          @description
        end

        def description?
          @description != nil
        end

        def type?(type)
          @type == type
        end

        def label?
          !@label.nil?
        end

        def label(form)
          return @label if @label
          form.object.class.human_attribute_name @name
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
