class Json < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :data, :text, size: :medium
  end
end
