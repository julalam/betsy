class AddZipcode < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :zip_code, :string
  end
end
