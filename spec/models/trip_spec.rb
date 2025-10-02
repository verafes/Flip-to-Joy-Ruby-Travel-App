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
    
  after(:each) do
    Trip.delete_all
    User.where(email: 'agent@example.com').delete_all
  end

  describe 'validations' do
    it 'is valid with all required attributes' do
      trip = Trip.new(
        user: agent,
        destination: 'Barcelona',
        meeting_point: 'Airport',
        minimum_persons: 2,
        maximum_persons: 5,
        price: 150.0
      )
      expect(trip).to be_valid
    end

    it 'is valid when minimum_persons is exactly 1' do
      trip = Trip.new(
        user: agent,
        destination: 'Barcelona',
        meeting_point: 'Airport',
        minimum_persons: 1,
        maximum_persons: 3,
        price: 500
      )
      expect(trip).to be_valid
    end

    it 'is valid when maximum_person is equal to minimum_person' do
      trip = Trip.new(
        user: agent,
        destination: 'Barcelona',
        meeting_point: 'Airport',
        minimum_persons: 2,
        maximum_persons: 2,
        price: 500
      )
      expect(trip).to be_valid
    end

    it 'is valid when price is 0' do
      trip = Trip.new(
        user: agent,
        destination: 'Barcelona',
        meeting_point: 'Airport',
        minimum_persons: 1,
        maximum_persons: 2,
        price: 0
      )
      expect(trip).to be_valid
    end 

    it 'is invalid without a destination' do
      trip = Trip.new(
        user: agent,
        meeting_point: 'Airport',
        minimum_persons: 2,
        maximum_persons: 5,
        price: 150.0
      )
      trip.validate
      expect(trip.errors[:destination]).to include("can't be blank")
    end

    it 'is invalid without a user' do
      trip = Trip.new(
        destination: 'Barcelona',
        meeting_point: 'Shibuya Station',
        minimum_persons: 1,
        maximum_persons: 2,
        price: 500
      )
      expect(trip).not_to be_valid
      expect(trip.errors[:user]).to include("must exist")
    end

    it 'is invalid when price is not a number' do
      trip = Trip.new(
        user: agent,
        destination: 'Barcelona',
        meeting_point: 'Airport',
        minimum_persons: 1,
        maximum_persons: 3,
        price: 'abc'
      )
      expect(trip).not_to be_valid
      expect(trip.errors[:price]).to include("is not a number")
    end

    it 'is invalid when minimum_persons is not an integer' do
      trip = Trip.new(
        user: agent,
        destination: 'Barcelona',
        meeting_point: 'Airport',
        minimum_persons: 'two',
        maximum_persons: 3,
        price: 100
      )
      expect(trip).not_to be_valid
      expect(trip.errors[:minimum_persons]).to include("is not a number")
    end
  end
end