class AddAccountIdToWebsites < ActiveRecord::Migration[5.1]
  def change
    add_column :websites, :account_id, :integer
  end
end
