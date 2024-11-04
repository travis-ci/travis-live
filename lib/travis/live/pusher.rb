# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../..', File.dirname(__FILE__)))

require 'metriks/librato_metrics_reporter'
require 'travis/live/config'
require 'travis/live/pusher/worker'
require 'travis/live/middleware/logging'
require 'travis/metrics/sidekiq'
require 'travis/exceptions'
require 'travis/exceptions/sidekiq'
require 'travis/support/logging'
require 'travis/support/logger'
require 'sidekiq-pro'

module Travis
  class << self
    def env
      ENV['ENV'] || ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
    end

    def logger
      @_logger ||= Logger.configure(Logger.new($stdout))
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

def redis_ssl_params(config)
  @redis_ssl_params ||=
    begin
      return nil unless config.redis.ssl

      value = {}
      value[:ca_path] = ENV['REDIS_SSL_CA_PATH'] if ENV['REDIS_SSL_CA_PATH']
      value[:cert] = OpenSSL::X509::Certificate.new(File.read(ENV['REDIS_SSL_CERT_FILE'])) if ENV['REDIS_SSL_CERT_FILE']
      value[:key] = OpenSSL::PKEY::RSA.new(File.read(ENV['REDIS_SSL_KEY_FILE'])) if ENV['REDIS_SSL_KEY_FILE']
      value[:verify_mode] = OpenSSL::SSL::VERIFY_NONE if config.ssl_verify == false
      value
    end
end
Sidekiq.configure_server do |config|
  pro = ::Sidekiq::NAME == 'Sidekiq Pro'

  if pro
    config.super_fetch!
    config.reliable_scheduler!
  end

  config.redis = {
    url: Travis.config.redis.url,
    id: nil,
    ssl: Travis.config.redis.ssl || false,
    ssl_params: redis_ssl_params(Travis.config)
  }
  config.server_middleware do |chain|
    chain.add Travis::Metrics::Sidekiq
    chain.add Travis::Live::Middleware::Logging

    chain.add Travis::Exceptions::Sidekiq if Travis.config.sentry
  end
end

Travis::Exceptions.setup(Travis.config, Travis.config.env, Travis.logger) if Travis.config.sentry

Travis::Metrics.setup(Travis.config.metrics, Travis.logger)
