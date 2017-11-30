module DynamicScaffold
  module Form
    class RadioButtons < CheckablesBase
      def render(form)
        form.collection_radio_buttons(@name, @query, @value_method, @text_method) do |builder|
          yield builder
        end
      end
    end
  end
end
