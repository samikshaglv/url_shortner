FactoryBot.define do
  factory :tiny_url do
    long_url { Faker::Internet.url } # Generate a random URL
    short_token { SecureRandom.urlsafe_base64(8) } # Generate a random short token
    expiration_date { 30.days.from_now } # Default expiration date 30 days from now
  end
end
