class TripsController < ApplicationController

  # GET /trips
  def index
    @trips = Trip.all
  end

  # GET /trips/1
  def show
    @trip = Trip.find(params[:id])
  end

  def new
     @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user = current_user
  if @trip.save
    redirect_to @trip, notice: "Trip was successfully created."
  else
    render :new, status: :unprocessable_entity
  end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(
      :destination, :description, :meeting_point,
        :start_time, :end_time, :minimum_person, :maximum_person,
        :booking_deadline, :is_recurring_schedule, :price
      ).merge(user_id: current_user.id)
  end

end
