class Checker
  include HTTParty

  LOG_LIMIT = 500

  attr_reader :response_time, :status_code

  def initialize(response_time, code)
    @response_time = response_time
    @status_code = code
  end

  def self.check(website)
    started = Time.now.to_f
    check = Checker.new(0, 500)
    begin
      res = HTTParty.get(website.url)
      check = Checker.new((Time.now.to_f - started).round(2), res.code)
    rescue
    end

    log_check!(website.id, check)
    return check 
  end

  def self.log_for_website(website_id, last = 100)
    last = LOG_LIMIT if last.to_i > LOG_LIMIT
    {
      status_codes: REDIS_CLIENT.lrange("website:#{website_id}:status_codes",0,last - 1).collect {|entry| JSON.parse(entry) },
      response_times: REDIS_CLIENT.lrange("website:#{website_id}:response_times",0,last - 1).collect {|entry| JSON.parse(entry) }
    }
  end

  def self.log_check!(website_id, check)
    check_time = Time.now.to_i
    REDIS_CLIENT.multi do
      REDIS_CLIENT.lpush "website:#{website_id}:status_codes", {code: check.status_code, time: check_time}.to_json
      REDIS_CLIENT.lpush "website:#{website_id}:response_times", {response_time: check.response_time, time: check_time}.to_json
      REDIS_CLIENT.ltrim "website:#{website_id}:status_codes",0,LOG_LIMIT - 1
      REDIS_CLIENT.ltrim "website:#{website_id}:response_times",0,LOG_LIMIT - 1
    end
  end

  def success?
    status_code == 200
  end

  def failed?
    !success?
  end
end