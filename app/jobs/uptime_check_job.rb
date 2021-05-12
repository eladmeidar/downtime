class UptimeCheckJob < ApplicationJob
  queue_as :uptime_checks
  sidekiq_options retry: false

  def perform(website_id)
    website = Website.find(website_id)
    begin
      started = Time.now.to_f
      res = HTTParty.get(website.url)
      website.update_attributes({
        status_code: res.code,
        last_check_at: DateTime.now,
        response_time_in_seconds: (Time.now.to_f - started).round(2)
      })
      website.notify! if res.code != 200
    rescue
      website.update_attributes({
        status_code: 500,
        last_check_at: DateTime.now,
        response_time_in_seconds: (Time.now.to_f - started).round(2)
      })
      website.notify!
    end
    website.reload
    if website.active?
      UptimeCheckJob.set(wait: website.run_interval_in_seconds.seconds).perform_later(website_id)
    end
  end
end
