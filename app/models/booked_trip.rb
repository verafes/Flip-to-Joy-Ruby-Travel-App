class BookedTrip < ApplicationRecord
  belongs_to  :trip
  belongs_to  :traveler, class_name: 'User', foreign_key: :user_id
end
