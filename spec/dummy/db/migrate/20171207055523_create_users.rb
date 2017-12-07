class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :encrypted_password
      t.integer :role, limit: 2

      t.timestamps
    end
  end
end
