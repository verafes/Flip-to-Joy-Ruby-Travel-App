class OpenTripsController < ApplicationController
  before_action :authenticate_user!

  def index
    @open_trips = Trip.all
    if params[:q].present?
      @open_trips = @open_trips.where("LOWER(destination) LIKE ?", "#{params[:q].downcase}%")
    end
  end
end