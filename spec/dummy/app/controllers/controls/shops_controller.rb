module Controls
  class ShopsController < BaseController
    include DynamicScaffold::Controller
    dynamic_scaffold Shop do |c|
      c.list.item(:id, style: 'width: 80px').label('Number')
      c.list.item :name, style: 'width: 120px'
      c.list.item :updated_at, style: 'width: 180px' do |rec, name|
        rec.fdate name, '%Y-%m-%d %H:%M:%S'
      end
      c.list.item(:created_at, style: 'width: 180px').label 'Create Date' do |rec, name|
        rec.fdate name, '%Y-%m-%d %H:%M:%S'
      end
      c.list.item do |rec, _name|
        link_to "Show #{rec.name}", controls_master_shops_path
      end

      # You can use form helper methods like ...
      # text_field, check_box, radio_button, password_field, hidden_field, file_field, text_area, color_field
      # collection_check_boxes, collection_radio_buttons, collection_select, grouped_collection_select
      c.form.hidden_field(:id)

      # `label` method change label from I18n model attribute name.
      c.form.text_field(:name).label 'Shop Name'

      # Last hash arg is given to HTML attributes.
      c.form.text_area :memo, rows: 8
      c.form.collection_select(
        :category_id, Category.all, :id, :name, include_blank: 'Select Category'
      )
      c.form.collection_check_boxes(:state_ids, State.all, :id, :name)
      c.form.collection_radio_buttons(:status, Shop.statuses.map {|k, _v| [k, k.titleize] }, :first, :last)

      c.form.block :block do |form, field|
        content_tag :div do
          form.text_field field.name, class: 'form-control'
        end
      end
      c.form.block(:block_with_label).label 'Block with label' do |form, field|
        form.text_field field.name, class: 'form-control'
      end
    end

    private

      def before_save_scaffold(record, _prev)
        raise DynamicScaffoldSpecError, record.name
      end
  end
end
