module DynamicScaffold
  class FormElement
    attr_accessor :label, :description
    def initialize(*args)
      @html_attrs = args.extract_options!
      class_attr = @html_attrs.delete(:class)
      @classnames = ['form-control']
      @classnames.push(class_attr) if class_attr

      @attribute_name = args[0]
      @type = args[1]
      self.label = args[2]
    end

    def render(form, record)
      options = @html_attrs.merge(class: @classnames.join(' '))
      form.public_send(@type, @attribute_name, options)
    end

    def description?
      self.description != nil
    end

    def type?(type)
      @type == type
    end
  end
end