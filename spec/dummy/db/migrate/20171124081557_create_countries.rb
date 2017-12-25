class CreateCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :countries do |t|
      t.string :name, null: false
      t.integer :sequence, null: false

      t.timestamps
    end
  end
end
