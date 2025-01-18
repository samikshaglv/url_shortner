class TinyUrl < ApplicationRecord
  before_create :create_unique_token
  before_save :set_default_expiration_date
  # Validations to prevent invalid inputs.
  validates :long_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: 'is not a valid URL' }
  validates :short_token, uniqueness: true

  # Scope to check if a URL is expired
  scope :not_expired, -> { where('expiration_date IS NULL OR expiration_date > ?', Time.current) }

  private

  # Generate a unique short token (with collision handling)
  def create_unique_token
    self.short_token = loop do
      token = SecureRandom.urlsafe_base64(5) # Short token of 5 characters
      break token unless TinyUrl.exists?(short_token: token)
    end
  end

  # Set default expiration date (30 days from creation) if not provided
  def set_default_expiration_date
    self.expiration_date ||= 30.days.from_now
  end
end
