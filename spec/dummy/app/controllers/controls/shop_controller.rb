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
      m.list.item do |rec, name|
        link_to "Show #{rec.name}", controls_master_shop_path
      end

      m.editor.hidden_field :id
      m.editor.text_field(:name).label 'Shop Name'
      m.editor.text_area :memo, rows: 8
      m.editor.collection_select(
        :category_id, Category.all, :id, :name, include_blank: 'Select Category'
      )
      m.editor.collection_check_boxes(:states, State.all, :id, :name)
      m.editor.collection_radio_buttons(:status, Shop.statuses.map{|k, v| [v, k.titleize]}, :first, :last)
    end
  end
end
