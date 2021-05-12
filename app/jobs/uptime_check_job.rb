class UptimeCheckJob < ApplicationJob
  queue_as :uptime_checks
  sidekiq_options retry: false

  def perform(website_id)
    website = Website.find(website_id)
    begin
      
      check = Checker.check(website)

      website.update_attributes({
        status_code: check.status_code,
        last_check_at: DateTime.now,
        response_time_in_seconds: check.response_time
      })

      website.notify! if check.failed?
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
