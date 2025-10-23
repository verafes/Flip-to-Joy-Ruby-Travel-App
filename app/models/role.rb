class Role < ApplicationRecord
  def self.traveler
    find_by_name("traveler")
  end

  def self.travel_agent
    find_by_name("travel_agent")
  end
end
