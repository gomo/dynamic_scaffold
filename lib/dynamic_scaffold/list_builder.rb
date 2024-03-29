# frozen_string_literal: true

module DynamicScaffold
  class ListBuilder
    attr_writer :add_button, :edit_buttons, :destroy_buttons

    def initialize(config)
      @config = config
      @items = []
      @sorter = nil
      @order = []
      @title = nil
      @filter = nil
      @row_class_block = nil
      @add_button = true
      @edit_buttons = true
      @destroy_buttons = true
    end

    def pagination(options = nil)
      @pagination = List::Pagination.new(options) unless options.nil?

      @pagination
    end

    def page_param_name
      pagination ? pagination.param_name : nil
    end

    def sorter(params = nil)
      @sorter = params if params
      @sorter
    end

    def item(*args, &block)
      item = List::Item.new(@config, *args, block)
      @items << item
      item
    end

    def items
      if @items.empty?
        @config.model.column_names.each do |column|
          @items << List::Item.new(@config, column, nil)
        end
      end
      @items
    end

    def sorter_attribute
      @sorter.keys.first
    end

    def sorter_direction
      @sorter.values.first
    end

    def order(*args)
      @order = args unless args.empty?
      @order
    end

    def title(*args, &block)
      if args[0].is_a?(Symbol) || args[0].is_a?(String) || block_given?
        @title = {
          column_name: args[0],
          block: block
        }
      else
        record = args[0]
        return @config.controller.view_context.instance_exec(record, &@title[:block]) if @title[:block]

        record.public_send(@title[:column_name])
      end
    end

    def title?
      @title.present?
    end

    def build_sql(scope_params)
      sql = @config.model.all
      sql = sql.where scope_params
      ret = @config.controller.instance_exec(sql, &@filter) unless @filter.nil?
      sql = ret unless ret.nil?
      unless sql.is_a? ::ActiveRecord::Relation
        raise(
          Error::InvalidOperation,
          'You must return ActiveRecord::Relation from filter block'
        )
      end
      sql
    end

    def filter(&block)
      @filter = block if block_given?
      @filter
    end

    def row_class(record = nil, &block)
      if block_given?
        @row_class_block = block
      elsif record.present? && @row_class_block
        @config.controller.view_context.instance_exec(record, &@row_class_block)
      end
    end

    def add_button(&block)
      if block_given?
        @add_button_block = block
      elsif @add_button_block
        @config.controller.view_context.instance_exec(&@add_button_block)
      else
        @add_button
      end
    end

    def edit_buttons(record = nil, &block)
      if block_given?
        @edit_buttons_block = block
      elsif record.present? && @edit_buttons_block
        @config.controller.view_context.instance_exec(record, &@edit_buttons_block)
      else
        @edit_buttons
      end
    end

    def destroy_buttons(record = nil, &block)
      if block_given?
        @destroy_buttons_block = block
      elsif record.present? && @destroy_buttons_block
        @config.controller.view_context.instance_exec(record, &@destroy_buttons_block)
      else
        @destroy_buttons
      end
    end
  end
end
