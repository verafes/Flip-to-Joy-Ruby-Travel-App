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
      redirect_to booked_trip_path(@booked_trip), notice: "Payment successful!"
    else
      render :new, alert: "Payment failed"
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