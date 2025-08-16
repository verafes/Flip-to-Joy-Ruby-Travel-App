class AddPriceToTrips < ActiveRecord::Migration[8.0]
  def change
    add_column :trips, :price, :decimal
  end
end
