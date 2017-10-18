$:.unshift(File.expand_path('../..', File.dirname(__FILE__)))

require 'metriks/librato_metrics_reporter'
require 'travis/live/config'
require 'travis/live/pusher/worker'
require 'travis/live/middleware/metriks'
require 'travis/live/middleware/logging'
require 'travis/exceptions'
require 'travis/exceptions/sidekiq'
require 'travis/support/logging'
require 'travis/support/logger'
require 'travis/support/metrics'
require 'sidekiq-pro'

module Travis
  class << self
    def env
     ENV['ENV'] || ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
    end

    def logger
      @logger ||= Logger.configure(Logger.new(STDOUT))
    end

    def logger=(logger)
      @logger = Logger.configure(logger)
    end

    def uuid=(uuid)
      Thread.current[:uuid] = uuid
    end

    def uuid
      Thread.current[:uuid] ||= SecureRandom.uuid
    end
  end
end

$stdout.sync = true

Sidekiq.configure_server do |config|
  pro = ::Sidekiq::NAME == 'Sidekiq Pro'

  if pro
    config.super_fetch!
    config.reliable_scheduler!
  end

  config.redis = {
    :url       => Travis.config.redis.url,
    :namespace => Travis.config.sidekiq.namespace
  }
  config.server_middleware do |chain|
    chain.add Travis::Live::Middleware::Metriks
    chain.add Travis::Live::Middleware::Logging

    if Travis.config.sentry
      chain.add Travis::Exceptions::Sidekiq
    end
  end
end

if Travis.config.sentry
  Travis::Exceptions.setup(Travis.config, Travis.config.env, Travis.logger)
end

Travis::Metrics.setup(Travis.config.metrics.reporter)
