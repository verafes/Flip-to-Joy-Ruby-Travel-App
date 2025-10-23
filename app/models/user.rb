class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :role

  has_many :trips, dependent: :destroy
  has_many :booked_trips, class_name: "BookedTrip", foreign_key: :user_id
  has_many :trips_as_traveler, through: :booked_trips, source: :trip

  validates :email, presence: true, uniqueness: true
  validates :role_id, presence: true

  def is_traveler?
      role.name == "traveler"
    end

    def is_travel_agent?
      role.name == "travel_agent"
    end
end
