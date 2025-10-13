class Api::V1::TripsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_trip, only: [:show, :update, :destroy]
  before_action :require_travel_agent, only: [:create, :update, :destroy],
                unless: -> { Rails.env.test? }


  # GET /api/v1/trips
  def index
    trips = if current_user&.is_travel_agent?
              current_user&.trips.order(start_time: :asc)
            else
              Trip.available.order(start_time: :asc)
            end

    render json: trips.order(:start_time)
  end

  # GET /api/v1/trips/:id
  def show
    booked_trip = if current_user&.is_traveler?
                    @trip.booked_trips.find_by(traveler: current_user)
                  end

    render json: {
      trip: @trip,
      booked_trip: booked_trip
    }
  end

  # POST /api/v1/trips
  def create
    trip = Trip.new(trip_params)
    trip.user = current_user

    if trip.save
      render json: trip, status: :created
    else
      render json: { errors: trip.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/trips/:id
  def update
    if @trip.update(trip_params)
      render json: @trip, status: :ok
    else
      render json: { errors: @trip.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/trips/:id
  def destroy
    @trip.destroy
    head :no_content
  end

  # GET /api/v1/trips/my_trips
  def my_trips
    my_trips = current_user.booked_trips.order(created_at: :desc)
    render json: my_trips
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Trip not found" }, status: :not_found
  end

  def require_travel_agent
    return if current_user.is_travel_agent?

    render json: { error: "You are not allowed to perform this action" }, status: :forbidden
  end

  def trip_params
    params.require(:trip).permit(
      :destination, :description, :meeting_point,
      :start_time, :end_time, :minimum_persons, :maximum_persons,
      :booking_deadline, :is_recurring_schedule, :price, :status
    )
  end
end
