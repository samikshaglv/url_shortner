require 'rails_helper'

RSpec.describe "Api::TinyUrls", type: :request do
  let(:token) { JsonWebToken.encode({ client_id: "external-client" }) } # Generate a valid token
  let(:headers) { { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" } }

  describe "POST /api/tiny_urls" do
    it "creates a shortened URL with a valid token" do
      debugger
      post "/api/tiny_urls", params: { tiny_url: { long_url: "https://example.com" } }.to_json, headers: headers
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json).to have_key("short_url")
    end

    it "returns an error with an invalid token" do
      headers["Authorization"] = "Bearer invalid_token"

      post "/api/tiny_urls", params: { tiny_url: { long_url: "https://example.com" } }.to_json, headers: headers

      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Unauthorized")
    end
  end

  describe "GET /:short_token" do
    let!(:tiny_url) { create(:tiny_url) } # Create a test record using FactoryBot

    it "redirects to the original URL if the token is valid and not expired" do
      get "/#{tiny_url.short_token}"

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(tiny_url.long_url)
    end

    it "returns an error if the URL is expired" do
      expired_url = create(:tiny_url, expiration_date: 1.day.ago) # Create an expired URL

      get "/#{expired_url.short_token}"

      expect(response).to have_http_status(:gone)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("URL not found or expired")
    end

    it "returns an error if the token does not exist" do
      get "/nonexistent-token"

      expect(response).to have_http_status(:gone)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("URL not found or expired")
    end
  end
end
