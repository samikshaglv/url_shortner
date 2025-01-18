require 'rails_helper'

RSpec.describe TinyUrl, type: :model do
  # Use FactoryBot to generate test data
  let(:tiny_url) { build(:tiny_url) } # `build` creates an in-memory object without saving it to the database

  describe 'Validations' do
    it 'is valid with valid attributes' do
      tiny_url = build(:tiny_url)
      expect(tiny_url).to be_valid
    end

    it 'is invalid without a long_url' do
      tiny_url = build(:tiny_url, long_url: nil)
      expect(tiny_url).not_to be_valid
      expect(tiny_url.errors[:long_url]).to include("can't be blank")
    end

    it 'is invalid with an improperly formatted long_url' do
      tiny_url = build(:tiny_url, long_url: 'invalid-url')
      expect(tiny_url).not_to be_valid
      expect(tiny_url.errors[:long_url]).to include('is not a valid URL')
    end
  end

  describe 'Callbacks' do
    it 'generates a unique short_token before creation' do
      tiny_url.save # Persist the record, triggering the `before_create` callback
      expect(tiny_url.short_token).not_to be_nil
      expect(tiny_url.short_token.length).to eq(8) # Assuming SecureRandom generates an 8-character token
    end

    it 'sets a default expiration_date if none is provided' do
      tiny_url.expiration_date = nil # Clear the expiration date
      tiny_url.save
      expect(tiny_url.expiration_date).not_to be_nil
      expect(tiny_url.expiration_date).to be_within(1.second).of(30.days.from_now) # Default expiration is 30 days
    end
  end

  describe 'Scopes' do
    let!(:expired_url) { create(:tiny_url, expiration_date: 1.day.ago) } # Create an expired record
    let!(:active_url) { create(:tiny_url, expiration_date: 1.day.from_now) } # Create a non-expired record

    it 'returns only non-expired URLs with the `not_expired` scope' do
      result = TinyUrl.not_expired
      expect(result).to include(active_url)
      expect(result).not_to include(expired_url)
    end
  end

  describe 'Methods' do
    it 'correctly determines if a URL is expired' do
      tiny_url.expiration_date = 1.day.ago
      expect(tiny_url.expired?).to be true

      tiny_url.expiration_date = 1.day.from_now
      expect(tiny_url.expired?).to be false
    end
  end
end
