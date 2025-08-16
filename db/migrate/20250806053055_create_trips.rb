class CreateTrips < ActiveRecord::Migration[8.0]
  def change
    create_table :trips do |t|
      t.text :destination
      t.text :description
      t.text :meeting_point
      t.datetime :start_time
      t.datetime :end_time
      t.integer :minimum_person
      t.integer :maximum_person
      t.datetime :booking_deadline
      t.boolean :is_recurring_schedule
      t.string :image
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
