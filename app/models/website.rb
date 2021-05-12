class Website < ApplicationRecord

  validates :url, presence: true
  after_create :schedule_job

  belongs_to :account

  def notify!
    if callback_url.present?
      begin
        HTTParty.post(callback_url, body: self.to_json, headers: { "User-Agent" => "Downtime #{self.account.access_token}"})
      rescue
      end
    end
  end

  def as_json(options)
    {
      id: id,
      callback_url: callback_url,
      last_check_at: last_check_at,
      response_time_in_seconds: response_time_in_seconds,
      check_interval: run_interval_in_seconds,
      last_status_code: status_code,
      active: active
    }
  end
  
  private

  def schedule_job
    UptimeCheckJob.set(wait: run_interval_in_seconds.seconds).perform_later(id)
  end
end
