require 'rails_helper'

RSpec.describe Trip, type: :model do
  let(:role) { Role.find_or_create_by(name: 'travel_agent') }

  let(:agent) do
    User.find_by(email: 'agent@example.com') ||
      User.create!(
        email: 'agent@example.com',
        password: 'NewPassw@rd123!',
        role: role
      )
    end

  describe 'validations' do
    it 'is valid with all required attributes' do
      trip = Trip.new(
        user: agent,
        destination: 'Barcelona',
        meeting_point: 'Airport',
        minimum_person: 2,
        maximum_person: 5,
        price: 150.0
      )
      expect(trip).to be_valid
    end

    it 'is invalid without a destination' do
      trip = Trip.new(
        user: agent,
        meeting_point: 'Airport',
        minimum_person: 2,
        maximum_person: 5,
        price: 150.0
      )
      trip.validate
      expect(trip.errors[:destination]).to include("can't be blank")
    end
  end
end