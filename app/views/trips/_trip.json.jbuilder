json.extract! trip, :id, :start_time, :end_time, :minimum_person, :maximum_person, :booking_deadline, :is_recurring_schedule, :created_at, :updated_at
json.url trip_url(trip, format: :json)