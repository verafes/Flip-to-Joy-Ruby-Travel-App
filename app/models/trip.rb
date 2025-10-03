class Trip < ApplicationRecord
  belongs_to :user # travel agent who created the trip
  has_many :booked_trips
  has_many :travelers, through: :booked_trips, source: :traveler

  enum status: { 
    open: 0, 
    closed: 1, 
    past: 2 
  }
  scope :available, -> { where(status: :open).where("start_time >= ?", Date.today) }

  validates :destination, presence: true
  validates :meeting_point, presence: true
  validates :minimum_persons, numericality: { only_integer: true, greater_than: 0 }
  validates :maximum_persons, numericality: { only_integer: true, greater_than_or_equal_to: :minimum_persons }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  def open_for_booking?
    open? && (booking_deadline.nil? || booking_deadline >= Date.today)
  end

  def mark_past!
    update(status: :past) if start_time < Date.today
  end
end
