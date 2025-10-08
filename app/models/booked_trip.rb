class BookedTrip < ApplicationRecord
  belongs_to  :trip
  belongs_to  :traveler, class_name: 'User', foreign_key: :user_id
  has_many :payments, dependent: :destroy
  
  validates :trip_id, uniqueness: { scope: :user_id, 
                                    message: "You have already booked this trip." }
end
