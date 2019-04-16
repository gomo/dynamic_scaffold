class AddColumnShopDates < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :foo_date, :date
    add_column :shops, :bar_date, :date
    add_column :shops, :quz_datetime, :datetime
  end
end
