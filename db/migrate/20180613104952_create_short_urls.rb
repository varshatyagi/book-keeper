class CreateShortUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :short_urls do |t|
      t.string      "short_url"
      t.string      "associated_url"
      t.string      "url_code"
      t.timestamps
    end
  end
end
