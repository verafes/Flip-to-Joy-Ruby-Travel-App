require 'rails_helper'

RSpec.describe "Trips", type: :request do
  let!(:role) { Role.create!(name: "travel_agent") }
  let!(:agent) do
    User.create!(email: 'agent@example.com', password: 'password123', role: role)
  end

  def valid_trip_params
    {
      user: agent,
      start_time: Time.now,
      end_time: Time.now + 1.hour,
      minimum_person: 1,
      maximum_person: 5,
      booking_deadline: Time.now,
      is_recurring_schedule: false,
      meeting_point: "Airport",
      destination: "Barselona",
      price: 150.0
    }
  end

  describe "GET /index" do
    it "returns http success" do
      get trips_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /trips/:id" do
    let(:trip) { Trip.create!(valid_trip_params) }

    it "returns http success" do
      get trips_path
      expect(response).to have_http_status(:ok)
    end

    it "returns http success for an existing trip" do
      get trip_path(trip)
      expect(response).to have_http_status(:ok)
    end

    it "returns not found for a non-existing trip" do
      get "/trips/999999"
      expect(response).to have_http_status(:not_found).or have_http_status(:redirect)
    end
  end

  describe "GET /trips/new" do
    it "returns http success" do
      get new_trip_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /trips/:id/edit" do
    let!(:trip) { Trip.create!(valid_trip_params.merge(user: agent)) }

    it "returns http success" do
      get edit_trip_path(trip)
      expect(response).to have_http_status(:success)
    end
  end
end
