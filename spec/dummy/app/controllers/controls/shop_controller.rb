module Controls
  class ShopController < ApplicationController
    include DynamicScaffold::Controller
    dynamic_scaffold Shop do |m|
      m.list.item(:id, style: 'width: 80px').label('Number')
      m.list.item :name, style: 'width: 120px'
      m.list.item :updated_at, style: 'width: 180px' do |rec, name|
        rec.fdate name, '%Y-%m-%d %H:%M:%S'
      end
      m.list.item(:created_at, style: 'width: 180px').label 'Create Date' do |rec, name|
        rec.fdate name, '%Y-%m-%d %H:%M:%S'
      end
      m.list.item do |rec, _name|
        link_to "Show #{rec.name}", controls_master_shop_path
      end

      # You can use form helper methods like ...
      # text_field, check_box, radio_button, password_field, hidden_field, file_field, text_area, color_field
      # collection_check_boxes, collection_radio_buttons, collection_select, grouped_collection_select
      m.form.hidden_field :id

      # `label` method change label from I18n model attribute name.
      m.form.text_field(:name).label 'Shop Name'

      # Last hash arg is given to HTML attributes.
      m.form.text_area :memo, rows: 8
      m.form.collection_select(
        :category_id, Category.all, :id, :name, include_blank: 'Select Category'
      )
      m.form.collection_check_boxes(:state_ids, State.all, :id, :name)
      m.form.collection_radio_buttons(:status, Shop.statuses.map {|k, _v| [k, k.titleize] }, :first, :last)
    end

    def create
      @record = @dynamic_scaffold.model.new
      @record.attributes = record_params
      if @record.save
        redirect_to controls_master_shop_path
      else
        render 'controls/shop/new'
      end
    end

    private

      def record_params
        params
          .require(@dynamic_scaffold.model.name.underscore)
          .permit(*@dynamic_scaffold.form.fields.map(&:strong_parameter))
      end
  end
end
