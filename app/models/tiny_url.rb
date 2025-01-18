class TinyUrl < ApplicationRecord
  before_create :create_unique_token
  # Validations to prevent invalid inputs.
  validates :long_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: 'is not a valid URL' }
  validates :short_token, uniqueness: true

  private

  # Generate a unique short token (with collision handling)
  def create_unique_token
    self.short_token = loop do
      token = SecureRandom.urlsafe_base64(5) # Short token of 5 characters
      break token unless TinyUrl.exists?(short_token: token)
    end
  end
end
