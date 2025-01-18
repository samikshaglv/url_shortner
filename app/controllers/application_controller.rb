class ApplicationController < ActionController::API
  before_action :authenticate_with_jwt

  # Authenticate API requests using JWT token
  def authenticate_with_jwt
    token = request.headers['Authorization']&.split(' ')&.last # Extract the token from the Authorization header
    @decoded_token = JsonWebToken.decode(token) # Decode the token

    # If the token is invalid or expired, return an error
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @decoded_token
  end

  # Access the decoded token payload (e.g., client info)
  def current_client
    @decoded_token
  end
end
