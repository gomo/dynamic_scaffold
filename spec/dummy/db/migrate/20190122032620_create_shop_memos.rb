class CreateShopMemos < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_memos do |t|
      t.references :shop, foreign_key: true, null: false
      t.string :title, null: false
      t.text :body, null: false
    end
  end
end
