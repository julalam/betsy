class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :customer_name
      t.string :customer_email
      t.string :customer_address
      t.string :cc_number
      t.date :cc_exipration
      t.string :cc_ccv

      t.timestamps
    end
  end
end
