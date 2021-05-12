class AddActiveToWebsites < ActiveRecord::Migration[6.0]
  def change
    add_column :websites, :active, :boolean, default: true
  end
end
