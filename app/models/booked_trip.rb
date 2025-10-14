class BookedTrip < ApplicationRecord
  belongs_to  :trip
  belongs_to  :traveler, class_name: 'User', foreign_key: :user_id
  has_many :payments, dependent: :destroy

  enum :status, {
      pending_payment: 0,
      paid: 1,
      cancelled: 2
    }
  attribute :status, :integer, default: 0

  validates :trip_id, uniqueness: { scope: :user_id, 
                                    message: "You have already booked this trip." }

  def paid?
    super || payments.where(status: :completed).exists?
  end

  def payment_failed?
    payments.failed.exists?
  end

  def pending_payment?
    !paid? && !payment_failed? && !cancelled?
  end
end
