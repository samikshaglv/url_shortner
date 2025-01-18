class Api::TinyUrlsController < ApplicationController
  skip_before_action :authenticate_with_jwt, only: [:show]

  # POST /api/tiny_urls
  def create
    tiny_url = TinyUrl.new(tiny_url_params)

    if tiny_url.save
      render json: { short_url: short_url(tiny_url.short_token)}, status: :created
    else
      render json: { errors: tiny_url.errors.full_messages }, status: :unprocessable_entity
    end
  end

# GET /:short_token
  def show
    tiny_url = TinyUrl.find_by(short_token: params[:short_token])

    if tiny_url
      redirect_to tiny_url.long_url, allow_other_host: true
    else
      render json: { error: 'URL not found' }, status: :gone
    end
  end

  private

  # Strong params
  def tiny_url_params
    params.require(:tiny_url).permit(:long_url)
  end

  # Generate the full short URL
  def short_url(token)
    "#{request.base_url}/#{token}"
  end

  # Authenticate API token, checks the Authorization header for a valid token.
  def authenticate_api_token!
    api_token = request.headers['Authorization']&.split(' ')&.last # Extract the token
    unless ApiClient.exists?(token: api_token)
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
