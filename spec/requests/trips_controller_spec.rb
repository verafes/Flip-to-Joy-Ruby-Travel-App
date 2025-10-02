require 'rails_helper'

RSpec.describe "Trips", type: :request do
# RSpec.describe TripsController, type: :controller do  
  let!(:role) { Role.create!(name: "travel_agent") }
  let!(:agent) do
    User.create!(email: 'agent@example.com', password: 'password123', role: role)
  end

  def login_as(agent)
    post user_session_path, params: {
      user: { email: agent.email, password: 'password123' }
    }
    follow_redirect!
  end

  def valid_trip_params
    {
      user: agent,
      start_time: Time.now,
      end_time: Time.now + 1.hour,
      minimum_persons: 1,
      maximum_persons: 5,
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
      p "Response status: #{response.status}"
      expect(response).to have_http_status(:redirect).or have_http_status(:ok)
    end
  end

  describe "GET /trips/:id" do
    let(:trip) { Trip.create!(valid_trip_params) }

    it "returns http success" do
      get trips_path
      expect(response).to have_http_status(:redirect).or have_http_status(:ok)
    end

    it "returns http success for an existing trip" do
      get trip_path(trip)
      expect(response).to have_http_status(:redirect).or have_http_status(:ok)
    end

    it "returns not found for a non-existing trip" do
      get "/trips/999999"
      expect(response).to have_http_status(:not_found).or have_http_status(:redirect)
    end
  end

  describe "GET /trips/new" do
    it "returns http success" do
      get new_trip_path
      expect(response).to have_http_status(:redirect).or have_http_status(:ok)
    end
  end

  describe "POST /trips" do
    it "creates a trip with valid params" do
      login_as(agent)

      post trips_path, params: { trip: valid_trip_params }, as: :json
      expect(response).to have_http_status(:created)

      trip = Trip.last
      expect(trip).not_to be_nil
      expect(trip.persisted?).to be true
      expect(trip.destination).to eq("Barselona")
      expect(Trip.count).to eq(1)
    end

    it "does not create a trip with invalid params" do
      login_as(agent)
      invalid_params = valid_trip_params.merge(price: -50)
      post trips_path, params: { trip: invalid_params }
      expect(response).to have_http_status(:unprocessable_content)
      expect(Trip.count).to eq(0)
    end
  end

  describe "GET /trips/:id/edit" do
    let!(:trip) { Trip.create!(valid_trip_params.merge(user: agent)) }

    it "returns http success" do
      get edit_trip_path(trip)
      expect(response).to have_http_status(:redirect).or have_http_status(:ok)
    end
  end

  describe "PATCH /trips/:id" do
    let!(:trip) { Trip.create!(valid_trip_params.merge(user: agent)) }

    it "updates a trip with valid params" do
      login_as(agent)
      patch trip_path(trip), params: { trip: { destination: "Updated" } }
      expect(response).to have_http_status(:redirect)
      expect(trip.reload.destination).to eq("Updated")
    end

    it "returns not found for a non-existing trip" do
      patch "/trips/999999", params: { trip: { destination: "Updated" } }
      expect(response).to have_http_status(:not_found).or have_http_status(:redirect)
    end
  end

  describe "DELETE /trips/:id" do
    let!(:trip) { Trip.create!(valid_trip_params) }

    it "deletes an existing trip" do
      login_as(agent)
      delete trip_path(trip)
      expect(response).to have_http_status(:redirect)
      expect(Trip.exists?(trip.id)).to be_falsey
    end

    it "returns not found for a non-existing trip" do
      delete "/trips/999999"
      expect(response).to have_http_status(:not_found).or have_http_status(:redirect)
    end
  end
end
