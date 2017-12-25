class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :encrypted_password, null: false
      t.integer :role, limit: 2, null: false
      t.integer :sequence, null: false

      t.timestamps
    end
  end
end
