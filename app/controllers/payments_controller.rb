class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booked_trip, only: [:new, :create]

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(payment_params)
    @payment.booked_trip = @booked_trip
    @payment.status = :pending

    if @payment.save
      # to do: integrate a payment gateway (Stripe, PayPal, etc.)
      # for testing, mark it as completed immediately
      @payment.update(status: :completed, paid_at: Time.current)
      format.html { redirect_to trip_path(@booked_trip.trip), notice: "Payment completed!" }
      format.json { render json: @payment, status: :created }
    else
      format.html { flash.now[:alert] = "Payment failed"; render :new }
      format.json { render json: @payment.errors, status: :unprocessable_entity }
    end
  end

  private

  def set_booked_trip
    @booked_trip = BookedTrip.find(params[:booked_trip_id])
  end

  def payment_params
    params.require(:payment).permit(:amount, :payment_method)
  end
end