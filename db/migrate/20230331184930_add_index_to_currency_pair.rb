class AddIndexToCurrencyPair < ActiveRecord::Migration[7.0]
  def change
    add_index :currencies, :pair
  end
end
