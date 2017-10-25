class ChangeProductPriceDataTypeToInt < ActiveRecord::Migration[5.1]
  def change
    change_column :products, :price, :integer
  end
end
