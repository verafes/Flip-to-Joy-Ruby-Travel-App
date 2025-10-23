class Trip < ApplicationRecord
  belongs_to :user # travel agent who created the trip
  has_many :booked_trips
  has_many :travelers, through: :booked_trips, source: :traveler
  has_many :payments, through: :booked_trips

  enum :status, {
    open: 0,
    closed: 1,
    past: 2
  }
  scope :available, -> { where(status: :open).where("start_time >= ?", Date.today) }

  validates :destination, presence: true
  validates :meeting_point, presence: true
  validates :minimum_persons, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :maximum_persons, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: :minimum_persons }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  mount_uploader :image, ImageUploader

  def open_for_booking?
    open? && (booking_deadline.nil? || booking_deadline >= Date.today)
  end

  def mark_past!
    update(status: :past) if start_time < Date.today
  end

  def update_status_if_full!
    if booked_trips.count >= maximum_persons
      update(status: :closed) unless closed?
    elsif closed? && booked_trips.count < maximum_persons
      update(status: :open)
    end
  end
end
