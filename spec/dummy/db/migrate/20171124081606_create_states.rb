class CreateStates < ActiveRecord::Migration[5.1]
  def change
    create_table :states do |t|
      t.string :name
      t.integer :sequence
      t.references :country, foreign_key: true

      t.timestamps
    end
  end
end
