class CreateShops < ActiveRecord::Migration[5.1]
  def change
    create_table :shops do |t|
      t.string :name, null: false
      t.text :memo
      t.references :category, foreign_key: true
      t.integer :status, default: 0, null: false, limit: 1

      t.timestamps
    end
  end
end
