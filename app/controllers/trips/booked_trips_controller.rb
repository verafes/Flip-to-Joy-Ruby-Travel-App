class Trips::BookedTripsController < ApplicationController
  before_action :authenticate_user!

  def create
    booked_trip = BookedTrip.new(booking_params)
    if booked_trip.save!
      redirect_to my_trips_trips_path, notice: "Thank you for booking! Flip to Joy on your adventure!"
    else
      flash.now[:alert] = "Booking failed: #{booked_trip.errors.full_messages.to_sentence}"
      @trips = Trip.available.order(start_time: :asc)
      render "open_trips/index", status: :unprocessable_entity
    end
  end

  def destroy
    @booked_trip = current_user.booked_trips.find(params[:id])
    @booked_trip.destroy
    redirect_to my_trips_path, notice: "Booking cancelled successfully"
  end

  private

  def booking_params
    params[:booked_trip] = {
      trip_id: params[:trip_id]
    }
    params.require(:booked_trip).permit(:trip_id).merge(
      user_id: current_user.id,
    )
  end
end
