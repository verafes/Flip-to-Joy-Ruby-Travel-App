# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

roles = [ 'traveler', 'travel_agent' ]

roles.each do |role_name|
  Role.find_or_create_by(name: role_name)
end

puts "Roles seeded: #{Role.pluck(:name).join(', ')}"

# --- Users ---
agent_role = Role.find_by(name: 'travel_agent')
traveler_role = Role.find_by(name: 'traveler')

agent = User.find_or_create_by!(email: 'jane@example.com') do |u|
  u.password = 'a7&43Wcxy6ij'
  u.role = agent_role
end

traveler = User.find_or_create_by!(email: 'mary@example.com') do |u|
  u.password = 'NewPassw@rd123!'
  u.role = traveler_role
end

puts "✅ Users seeded: #{User.pluck(:email).join(', ')}"

# --- Trips (created by agent) ---
trips_data = [
  {
    destination: 'New York',
    start_time: Time.zone.parse('2025-09-14 18:00'),
    end_time: Time.zone.parse('2025-09-20 18:00'),
    minimum_persons: 2,
    maximum_persons: 8,
    meeting_point: 'Airport',
    price: 250.0,
    image: 'new-york.jpg'
  },
  {
    destination: 'Barcelona',
    start_time: Time.zone.parse('2025-10-24 18:00'),
    end_time: Time.zone.parse('2025-10-27 20:00'),
    minimum_persons: 2,
    maximum_persons: 8,
    meeting_point: 'Airport',
    price: 300.0,
    booking_deadline: Time.zone.parse('2025-10-17 18:00'),
    is_recurring_schedule: false,
    image: 'Barcelona.jpg'
  },
  {
    destination: 'Los Angeles',
    start_time: Time.zone.parse('2025-10-25 18:00'),
    end_time: Time.zone.parse('2025-10-28 18:00'),
    minimum_persons: 4,
    maximum_persons: 10,
    meeting_point: 'Bus station',
    price: 200.0,
    booking_deadline: Time.zone.parse('2025-10-24 18:00'),
    is_recurring_schedule: false,
    image: 'los-angeles.jpg'
  },
  {
    destination: 'San Francisco',
    start_time: Time.zone.parse('2025-11-01 19:00'),
    end_time: Time.zone.parse('2025-11-05 19:00'),
    minimum_persons: 2,
    maximum_persons: 10,
    meeting_point: 'Bus station',
    price: 250.0,
    booking_deadline: Time.zone.parse('2025-10-30 19:00'),
    is_recurring_schedule: false,
    image: 'SF-bridge.jpg'
  },
  {
    destination: 'Paris',
    start_time: Time.zone.parse('2025-11-10 18:00'),
    end_time: Time.zone.parse('2025-11-15 18:00'),
    minimum_persons: 2,
    maximum_persons: 6,
    meeting_point: 'Airport',
    price: 500.0,
    booking_deadline: Time.zone.parse('2025-11-07 18:00'),
    is_recurring_schedule: true,
    image: 'paris-eiffel-tower.jpg'
  }
]

trips_data.each do |data|
  trip = Trip.find_or_initialize_by(destination: data[:destination], user: agent)
  trip.assign_attributes(
    start_time: data[:start_time],
    end_time: data[:end_time],
    minimum_persons: data[:minimum_persons],
    maximum_persons: data[:maximum_persons],
    meeting_point: data[:meeting_point],
    price: data[:price],
    booking_deadline: data[:booking_deadline],
    recurring: data[:recurring],
    status: :open
  )
  trip.save!

  image_path = Rails.root.join('app', 'assets', 'images', data[:image_name])
  if File.exist?(image_path) && !trip.image.attached?
    trip.image.attach(
      io: File.open(image_path),
      filename: data[:image_name],
      content_type: 'image/jpeg'
    )
  end
end

puts "✅ Trips seeded: #{Trip.pluck(:destination).join(', ')}"

# --- Booked Trips ---
barcelona_trip = Trip.find_by(destination: 'Barcelona')
paris_trip = Trip.find_by(destination: 'Paris')

booked_barcelona = BookedTrip.find_or_create_by!(trip: barcelona_trip, traveler: traveler)
booked_paris = BookedTrip.find_or_create_by!(trip: paris_trip, traveler: traveler)

puts "✅ Booked trips created for traveler: #{traveler.email}"

# --- Payments ---
Payment.find_or_create_by!(booked_trip: booked_barcelona) do |payment|
  payment.amount = barcelona_trip.price
  payment.payment_method = 'credit_card'
  payment.status = :completed
end

[ booked_barcelona, booked_paris ].each do |booked_trip|
  status = if booked_trip.payment.present?
             "Paid"
  else
             "Pending payment"
  end

  puts "📍 Destination: #{booked_trip.trip.destination} — Status: #{status}"
end
