class OpenTripsController < ApplicationController
  before_action :authenticate_user!

  def index
      @trips = Trip.all.order(start_time: :asc) 
    if params[:q].present?
      @trips = @trips.where("LOWER(destination) LIKE ?", "#{params[:q].downcase}%")
    end
  end
end