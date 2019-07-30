module DynamicScaffold
  class FormBuilder
    def initialize(config)
      @config = config
      @items = []
      @permit_params = []
    end

    def items
      if @items.empty?
        @config.model.column_names.each do |column|
          type = :text_field
          type = :hidden_field if @config.scope && @config.scope.include?(column.to_sym)
          @items << Form::Item::SingleOption.new(@config, type, column)
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
      @items << item
      item
    end
  end
end
