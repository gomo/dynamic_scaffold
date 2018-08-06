class I18nShop < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :desc, :text
    add_column :shops, :keyword, :string
    reversible do |dir|
      dir.up do
        I18n.with_locale(:ja) do
          Shop.create_translation_table!({
            desc: :text,
            keyword: :string
          }, {
            :migrate_data => true,
            :remove_source_columns => true
          })
        end
      end

      dir.down do
        Shop.drop_translation_table! :migrate_data => true
      end
    end
  end
end
