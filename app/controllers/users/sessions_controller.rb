class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: { message: "Logged in successfully.", user: resource }, status: :ok
    else
      render json: { error: "Invalid email or password." }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    head :no_content
  end
end
