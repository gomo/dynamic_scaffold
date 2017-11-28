class CreateCountryAttributes < ActiveRecord::Migration[5.1]
  def change
    create_table :country_attributes, primary_key: %w[code country_id] do |t|
      t.string :code
      t.string :value
      t.references :country, foreign_key: true

      t.timestamps
    end
  end
end
