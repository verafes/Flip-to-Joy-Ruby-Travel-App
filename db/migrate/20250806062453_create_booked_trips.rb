class CreateBookedTrips < ActiveRecord::Migration[8.0]
  def change
    create_table :booked_trips do |t|
      t.references :user, null: false, foreign_key: true
      t.references :trip, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
