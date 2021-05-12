class AddLastStatusCodeToWebsites < ActiveRecord::Migration[5.1]
  def change
    add_column :websites, :status_code, :integer
  end
end
