class AddExpirationDateToTinyUrls < ActiveRecord::Migration[8.0]
  def change
    add_column :tiny_urls, :expiration_date, :datetime
  end
end
