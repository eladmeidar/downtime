class ChangeDurationTimeToFloat < ActiveRecord::Migration[5.1]
  def change
    change_column :websites, :response_time_in_seconds, :float
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
