class CreateShopStates < ActiveRecord::Migration[5.1]
  def change
    create_table :shop_states do |t|
      t.references :shop, foreign_key: true, null: false
      t.references :state, foreign_key: true, null: false

      t.timestamps
    end
  end
end
