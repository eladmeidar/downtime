class CreateWebsites < ActiveRecord::Migration[5.1]
  def change
    create_table :websites do |t|
      t.string :url
      t.datetime :last_check_at
      t.integer :response_time_in_seconds
      t.timestamps
    end
  end
end
