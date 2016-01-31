$LOAD_PATH << 'lib'

require 'metriks/librato_metrics_reporter'
require 'travis/live/error_handler'
require 'travis/live'
require 'travis/live/sidekiq/worker'
require 'travis/live/middleware/metriks'
require 'travis/live/middleware/logging'
require 'travis/support/exceptions'
require 'travis/support/logging'
require 'travis/support/logger'
require 'travis/support/metrics'

$stdout.sync = true

if Travis::Live.config.sentry.dsn
  require 'raven'
  Raven.configure do |config|
    config.dsn = Travis::Live.config.sentry.dsn

    config.current_environment = Travis.env
    config.environments = ["staging", "production"]
  end
end

Sidekiq.configure_server do |config|
  config.redis = {
    :url       => Travis::Live.config.redis.url,
    :namespace => Travis::Live.config.sidekiq.namespace
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

if Travis::Live.config.sentry
  Travis::Exceptions::Reporter.start
end

Travis::Metrics.setup(Travis::Live.config.metrics.reporter)
