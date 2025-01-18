class CreateTinyUrls < ActiveRecord::Migration[8.0]
  def change
    create_table :tiny_urls do |t|
      t.string :long_url
      t.string :short_token

      t.timestamps
    end
    add_index :tiny_urls, :short_token, unique: true
  end
end
