class Api::TinyUrlsController < ApplicationController
  # POST /api/tiny_urls
  def create
    tiny_url = TinyUrl.new(tiny_url_params)

    if tiny_url.save
      render json: { short_url: short_url(tiny_url.short_token)}, status: :created
    else
      render json: { errors: tiny_url.errors.full_messages }, status: :unprocessable_entity
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
end
