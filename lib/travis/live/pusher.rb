$:.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'bundler/setup'
require 'metriks/librato_metrics_reporter'
require 'travis/live/error_handler'
require 'travis/live/config'
require 'travis/live/pusher/worker'
require 'travis/live/middleware/metriks'
require 'travis/live/middleware/logging'
require 'unlimited-jce-policy-jdk7'

$stdout.sync = true

if Travis.config.sentry.dsn
  require 'raven'
  Raven.configure do |config|
    config.dsn = Travis.config.sentry.dsn

    config.current_environment = Travis.env
    config.environments = ["staging", "production"]
  end
end

Sidekiq.configure_server do |config|
  config.redis = {
    :url       => Travis.config.redis.url,
    :namespace => Travis.config.sidekiq.namespace
  }
  config.server_middleware do |chain|
    chain.add Travis::Live::Middleware::Metriks
    chain.add Travis::Live::Middleware::Logging

    if defined?(::Raven::Sidekiq)
      chain.remove(::Raven::Sidekiq)
    end

    chain.remove(Sidekiq::Middleware::Server::Logging)
    chain.add(Travis::Live::ErrorHandler)
  end
end

if Travis.config.sentry
  Travis::Exceptions::Reporter.start
end

Travis::Metrics.setup
