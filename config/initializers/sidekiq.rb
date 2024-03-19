config=YAML.load_file('config/redis.yml')

if Rails.env.production?
  redis_url = "redis://#{config["production"]["host"]}:#{config["production"]["port"]}/#{config["production"]["db"]}"
else 
  redis_url = "redis://#{config["default"]["host"]}:#{config["default"]["port"]}/#{config["default"]["db"]}"
end

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end
  
Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end