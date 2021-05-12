class AddCallbackUrlToWebsites < ActiveRecord::Migration[6.0]
  def change
    add_column :websites, :callback_url, :string
  end
end
