class Trip < ApplicationRecord
  belongs_to :user # travel agent who created the trip
  has_many :booked_trips
  has_many :travelers, through: :booked_trips, source: :traveler

  validates :destination, presence: true
  validates :meeting_point, presence: true
  validates :minimum_person, numericality: { only_integer: true, greater_than: 0 }
  validates :maximum_person, numericality: { only_integer: true, greater_than_or_equal_to: :minimum_person }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
