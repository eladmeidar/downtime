class AddRunIntervalToWebsites < ActiveRecord::Migration[5.1]
  def change
    add_column :websites, :run_interval_in_seconds, :integer, default: 60
  end
end
