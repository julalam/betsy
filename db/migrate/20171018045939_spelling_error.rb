class SpellingError < ActiveRecord::Migration[5.1]
  def change
    rename_column :orders, :cc_exipration, :cc_expiration
  end
end
