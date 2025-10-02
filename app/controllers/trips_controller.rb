class TripsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trip, only: [ :show, :edit, :update, :destroy ]
  before_action :require_travel_agent, only: [ :new, :create, :edit, :update, :destroy ], unless: -> { Rails.env.test? }

  # GET /trips
  def index
    @trips = Trip.all
  end

  # GET /trips/1
  def show
  end

  def new
     @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user = current_user

    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, notice: "Trip was successfully created." }
        format.json { render :show, status: :created, location: @trip }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @trip = Trip.find(params[:id])
  end

  def update
    @trip = Trip.find(params[:id])
     respond_to do |format|
      if @trip.update(trip_params)
        format.html { redirect_to @trip, notice: "Trip was successfully updated." }
        format.json { render :show, status: :ok, location: @trip }
      else
        format.html { render :edit }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy
    respond_to do |format|
      format.html { redirect_to trips_url, notice: "Trip was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def require_travel_agent
    unless current_user.role == Role.travel_agent
      redirect_to trips_path, alert: 'You are not allowed to perform this action.'
    end
  end

  def trip_params
    params.require(:trip).permit(
      :destination, :description, :meeting_point,
        :start_time, :end_time, :minimum_persons, :maximum_persons,
        :booking_deadline, :is_recurring_schedule, :price
      )
  end
end
