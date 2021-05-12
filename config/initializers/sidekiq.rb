redis_config =  YAML.load(ERB.new(File.read(Rails.root.join('config','redis.yml'))).result)
redis_config.merge! redis_config.fetch(Rails.env, {})

REDIS_CLIENT = Redis.new(host: redis_config[:host])

Sidekiq.configure_server do |config|
 config.redis = { url:redis_config[:host], size: 7, network_timeout: 5, 
  ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }
end
Sidekiq.configure_client do |config|
  config.redis = { url:redis_config[:host], size: 7, network_timeout: 5, 
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }
end