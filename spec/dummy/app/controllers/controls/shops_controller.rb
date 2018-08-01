module Controls
  class ShopsController < BaseController
    include DynamicScaffold::Controller
    dynamic_scaffold Shop do |c|
      c.max_count(5)
      c.list.title(:name)
      c.list.item(:id).label('Number')
      c.list.item :updated_at do |rec, name|
        rec.fdate name, '%Y-%m-%d %H:%M:%S'
      end
      c.list.item(:created_at).label 'Create Date' do |rec, name|
        rec.fdate name, '%Y-%m-%d %H:%M:%S'
      end
      c.list.item do |rec, _name|
        link_to "Show #{rec.name}", controls_master_shops_path
      end

      # You can use form helper methods like ...
      # text_field, check_box, radio_button, password_field, hidden_field, file_field, text_area, color_field
      # collection_check_boxes, collection_radio_buttons, collection_select, grouped_collection_select
      c.form.item(:hidden_field, :id)

      c.form.item(:carrierwave_image, :image, preview_max_size: { width: '450px' }, cropper: {
          aspectRatio: 1
      })

      # `label` method change label from I18n model attribute name.
      c.form.item(:text_field, :name).label 'Shop Name'

      locales = {en: 'English', ja: '日本語'}
      c.form.item(:globalize_fields, locales).for(:text_field, :keyword)
      c.form.item(:globalize_fields, locales).for(:text_area, :desc)

      # Last hash arg is given to HTML attributes.
      c.form.item :text_area, :memo, rows: 8
      c.form.item(:collection_select,
        :category_id, Category.all, :id, :name, include_blank: 'Select Category'
      )
      c.form.item(:collection_check_boxes, :state_ids, State.all, :id, :name)
      c.form.item(:collection_radio_buttons, :status, Shop.statuses.map {|k, _v| [k, k.titleize] }, :first, :last)
    end

    private

      def before_save_scaffold(record, _prev)
        raise DynamicScaffoldSpecError, record.name
      end
  end
end
