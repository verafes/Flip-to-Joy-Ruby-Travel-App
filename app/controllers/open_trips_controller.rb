class OpenTripsController < ApplicationController
  before_action :authenticate_user!

  def index
    @trips = Trip.all.order(start_time: :asc)
    if params[:q].present?
      @trips = @trips.where("LOWER(destination) LIKE ?", "#{params[:q].downcase}%")
      if @trips.any?
        flash.now[:notice] = "Showing trips matching '#{params[:q]}'"
      else
        flash.now[:alert] = "No trips found matching '#{params[:q]}'"
      end
    end

    if current_user&.is_traveler?
      @booked_trips = current_user.booked_trips.where(trip_id: @trips.map(&:id)).index_by(&:trip_id)
    else
      @booked_trips = {}
    end
  end
end