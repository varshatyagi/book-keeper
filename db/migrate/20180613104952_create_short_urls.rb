class CreateShortUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :short_urls do |t|
      t.string      "actual_url"
      t.string      "url_code"
      t.timestamps
    end
  end
end
