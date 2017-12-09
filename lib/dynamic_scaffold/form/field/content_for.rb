module DynamicScaffold
  module Form
    module Field
      class ContentFor < Base
        attr_reader :content_for_name

        def initialize(config, type, content_for_name, options = {})
          @options = options
          @content_for_name = content_for_name
          name = @options[:attribute_name] ? @options[:attribute_name] : content_for_name
          super(config, type, name)
        end

        def wrapper?
          return true unless @options.key? :wrapper
          !!@options[:wrapper]
        end
      end
    end
  end
end
