module Controls
  class ShopsController < BaseController
    include DynamicScaffold::Controller
    dynamic_scaffold Shop do |c| # rubocop:disable Metrics/BlockLength
      c.max_count(5)
      c.list.title(:name)
      c.list.item(:keyword)
      c.list.item(:id).label('Number')
      c.list.item :updated_at do |rec, name|
        rec.fdate name, '%Y-%m-%d %H:%M:%S'
      end
      c.list.item(:created_at) do |rec, name|
        rec.fdate name, '%Y-%m-%d %H:%M:%S'
      end.label 'Create Date'
      c.list.item do |rec, _name|
        link_to "Show #{rec.name}", controls_master_shops_path
      end.label('foo').show_only {|rec| rec.name != 'Hosnian Prime' }

      c.list.item do |_rec, _name|
        ''
      end.label('bar')

      # You can use form helper methods like ...
      # text_field, check_box, radio_button, password_field, hidden_field, file_field, text_area, color_field
      # collection_check_boxes, collection_radio_buttons, collection_select, grouped_collection_select
      c.form.item(:hidden_field, :id)

      c.form.item(:carrierwave_image, :image, cropper: {
        aspectRatio: 1
      }
      )

      # `label` method change label from I18n model attribute name.
      c.form.item(:text_field, :name).label(class: 'h2')

      locales = { en: 'English', ja: 'Japanese' }
      c.form.item(:globalize_fields, locales, style: 'width: 78px;').for(:text_field, :keyword).note do
        content_tag :p do
          out = []
          out << 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
          out << 'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
          out << tag(:br)
          out << 'Ut enim ad minim veniam, quis nostrud exercitation ullamco '
          out << 'laboris nisi ut aliquip ex ea commodo consequat. '
          out << tag(:br)
          safe_join(out)
        end
      end
      c.form.item(:globalize_fields, locales, style: 'width: 78px;').for(:text_area, :desc, rows: 10)

      # Last hash arg is given to HTML attributes.
      c.form.item(:text_area, :memo, rows: 8).label do |text|
        tag.label text, class: 'h1', style: 'color: red'
      end
      c.form.item(:collection_select,
        :category_id, Category.all, :id, :name, include_blank: 'Select Category'
      )
      c.form.item(:collection_check_boxes, :state_ids, State.all, :id, :name)
      c.form.item(:collection_radio_buttons, :status, Shop.statuses.map {|k, _v| [k, k.titleize] }, :first, :last)
      c.form.item(:date_field, :foo_date, min: '2018-01-01', max: '2018-1-31')
      c.form.item(:date_select, :bar_date)
      c.form.item(:datetime_select, :quz_datetime)
      c.form.item(:cocoon, :shop_memos, add_text: 'Add Memo') do |form|
        form.item(:hidden_field, :id)
        form.item(:text_field, :title).label(style: 'color: red;')
        form.item(:text_area, :body)
      end.filter do |records|
        # The records with empty id are first, then in descending order of id
        records.partition do |rec|
          rec.id.nil?
        end.yield_self do |nils, others|
          nils + others.sort_by {|rec| -rec.id }
        end
      end

      c.form.item(:json, :data, model: ShopData) do |form|
        form.item(:text_field, :foobar).label('Foobar')
      end
    end

    def create
      super do |record|
        record.locale_keywords_require = true
      end
    end

    def update
      super do |record|
        record.locale_keywords_require = true
      end
    end
  end
end
