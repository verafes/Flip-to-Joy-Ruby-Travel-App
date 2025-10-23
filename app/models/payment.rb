class Payment < ApplicationRecord
  belongs_to :booked_trip

  enum :status, {
    pending: 0,
    completed: 1,
    failed: 2
  }

  validates :amount, numericality: { greater_than: 0 }
  validates :payment_method, presence: true
end
