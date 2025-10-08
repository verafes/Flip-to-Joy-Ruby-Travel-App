class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :booked_trip, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.string :payment_method
      t.integer :status
      t.datetime :paid_at

      t.timestamps
    end
  end
end
