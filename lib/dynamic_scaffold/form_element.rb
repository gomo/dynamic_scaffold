module DynamicScaffold
  class FormElement
    attr_accessor :label, :description
    def initialize(*args)
      @html_attrs = args.extract_options!
      class_attr = @html_attrs.delete(:class)
      @classnames = []
      @classnames.push(class_attr) if class_attr

      @attribute_name = args[0]
      @type = args[1]
      self.label = args[2]
    end

    def render(form, html_attrs = {})
      class_attr = @html_attrs.delete(:class)

      classnames = class_attr ? @classnames.dup.push(class_attr) : @classnames
      options = classnames.size > 0 ? @html_attrs.merge(class: classnames.join(' ')) : @html_attrs
      form.public_send(@type, @attribute_name, options.merge(html_attrs))
    end

    def description?
      self.description != nil
    end

    def type?(type)
      @type == type
    end
  end
end