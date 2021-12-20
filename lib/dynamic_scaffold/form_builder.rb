# frozen_string_literal: true

module DynamicScaffold
  class FormBuilder
    attr_accessor :parent_item

    def initialize(config)
      @config = config
      @items = []
      @permit_params = []
    end

    def items
      if @items.empty?
        @config.model.column_names.each do |column|
          type = :text_field
          type = :hidden_field if @config.scope&.include?(column.to_sym)
          item = Form::Item::SingleOption.new(@config, type, column)
          item.parent_item = parent_item
          @items << item
        end
      end
      @items
    end

    def permit_params(*params)
      if params.empty?
        @permit_params
      else
        @permit_params.concat(params)
        self
      end
    end

    def item(type, *args, &block)
      item = Form::Item::Base.create(@config, type, *args, &block)
      item.parent_item = parent_item
      @items << item
      item
    end
  end
end
