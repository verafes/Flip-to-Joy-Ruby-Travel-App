require 'rails_helper'

RSpec.describe BookedTrip, type: :model do
  let(:traveler_role) { Role.find_or_create_by!(name: 'traveler') }
  let(:agent_role)    { Role.find_or_create_by(name: 'travel_agent') }

  let(:agent) do
    User.find_by(email: 'agent@example.com') ||
      User.create!(
        email: 'agent@example.com',
        password: 'NewPassw@rd123!',
        role: agent_role
      )
    end

  let(:traveler) do
    User.find_by(email: 'traveler@example.com') ||
      User.create!(
        email: 'traveler@example.com',
        password: 'Passw@rd321!',
        role: traveler_role
      )
    end  

  let(:trip) do
    Trip.create!(
      user: agent,
      destination: 'Paris',
      meeting_point: 'Airport',
      minimum_persons: 1,
      maximum_persons: 3,
      price: 100.0
    )
  end

  describe 'validations' do
    it 'is valid with a trip and traveler' do
      booked_trip = BookedTrip.new(trip: trip, traveler: traveler)
      expect(booked_trip).to be_valid
    end

    it 'is invalid without a trip' do
      booked_trip = BookedTrip.new(traveler: traveler)
      expect(booked_trip).not_to be_valid
      expect(booked_trip.errors[:trip]).to include("must exist")
    end

    it 'is invalid without a traveler' do
      booked_trip = BookedTrip.new(trip: trip)
      expect(booked_trip).not_to be_valid
      expect(booked_trip.errors[:traveler]).to include("must exist")
    end

    it 'belongs to the correct trip' do
      booked_trip = BookedTrip.new(trip: trip, traveler: traveler)
      expect(booked_trip.trip).to eq(trip)
    end

    it 'belongs to the correct traveler' do
      booked_trip = BookedTrip.new(trip: trip, traveler: traveler)
      expect(booked_trip.traveler).to eq(traveler)
    end
  end
end