class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.integer :stock
      t.boolean :retired
      t.text :description
      t.string :image_url
      t.integer :merchant_id

      t.timestamps
    end
  end
end
