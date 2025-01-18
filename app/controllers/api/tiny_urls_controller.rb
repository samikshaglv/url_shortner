class Api::TinyUrlsController < ApplicationController
  # Apply JWT authentication only to the `create` action
  skip_before_action :authenticate_with_jwt, only: [:show]

  # POST /api/tiny_urls
  def create
    tiny_url = TinyUrl.new(tiny_url_params)

    if tiny_url.save
      render json: { short_url: short_url(tiny_url.short_token), expiration_date: tiny_url.expiration_date }, status: :created
    else
      render json: { errors: tiny_url.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/tiny_url/:short_token
  def show
    tiny_url = TinyUrl.not_expired.find_by(short_token: params[:short_url])

    if tiny_url
      redirect_to tiny_url.long_url, allow_other_host: true
    else
      render json: { error: "URL not found or expired" }, status: :gone
    end
  end

  private

  # Strong parameters
  def tiny_url_params
    params.require(:tiny_url).permit(:long_url, :expiration_date)
  end

  # Generate the full short URL
  def short_url(token)
    "#{request.base_url}/#{token}"
  end
end
