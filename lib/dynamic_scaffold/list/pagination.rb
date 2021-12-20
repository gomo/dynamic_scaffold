# frozen_string_literal: true

module DynamicScaffold
  module List
    class Pagination
      attr_reader(
        :kaminari_options,
        :per_page,
        :total_count,
        :end_buttons,
        :neighbor_buttons,
        :gap_buttons,
        :highlight_current,
        :param_name
      )
      def initialize(options)
        options = {
          per_page: 25,
          window: 0,                # kaminari options
          outer_window: 0,          # kaminari options
          left: 0,                  # kaminari options
          right: 0,                 # kaminari options
          param_name: :page,        # kaminari options
          total_count: true,        # Whether to display total count on active page like `2 / 102`
          end_buttons: true,        # Whether to display buttons to the first and last page.
          neighbor_buttons: true,   # Whether to display buttons to the next and prev page.
          gap_buttons: false,       # Whether to display gap buttons.
          highlight_current: false # Whether to highlight the current page.
        }.merge(options)
        @kaminari_options = options.extract!(:window, :outer_window, :left, :right, :param_name)
        @param_name = @kaminari_options[:param_name]
        options.each {|name, value| instance_variable_set("@#{name}", value) }
      end

      def page_number(page, records)
        return page unless total_count

        "#{page} / #{records.total_pages}"
      end

      def page_class(page, _records)
        if page.inside_window?
          'inner'
        elsif page.left_outer?
          'left-outer'
        elsif page.right_outer?
          'right-outer'
        end
      end
    end
  end
end
