Sidekiq.configure_server do |config|
    config.redis = { url: 'redis://172.17.0.4:6379/4' }
  end
  
  Sidekiq.configure_client do |config|
    config.redis = { url: 'redis://172.17.0.4:6379/4' }
  end