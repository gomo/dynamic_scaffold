module DynamicScaffold
  module Form
    class CheckBoxes < CheckablesBase
      def render(form)
        form.collection_check_boxes(@name, @query, @value_method, @text_method) do |builder|
          yield builder
        end
      end
    end
  end
end
