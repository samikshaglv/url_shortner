class Api::AuthenticationController < ApplicationController
  # Skip JWT authentication for this endpoint (since it's generating tokens)
  skip_before_action :authenticate_with_jwt

  def authenticate
    client_id = params[:client_id]
    client_secret = params[:client_secret]

    # Validate the client credentials
    if client_id == 'external-client' && client_secret == 'secure-client-secret'
      # Generate a JWT token
      token = JsonWebToken.encode({ client_id: client_id })
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end
end
