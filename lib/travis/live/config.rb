# frozen_string_literal: true

require 'travis/config'
require 'pusher'

module Travis
  def self.config
    @_config ||= Live::Config.load
  end

  def self.pusher
    @_pusher ||= ::Pusher.tap do |pusher|
      pusher.scheme = config.pusher.scheme if config.pusher.scheme
      pusher.host   = config.pusher.host   if config.pusher.host
      pusher.port   = config.pusher.port   if config.pusher.port
      pusher.app_id = config.pusher.app_id
      pusher.key    = config.pusher.key
      pusher.secret = config.pusher.secret
    end
  end

  module Live
    class Config < Travis::Config
      HOSTS = {
        production: 'travis-ci.org',
        staging: 'staging.travis-ci.org',
        development: 'localhost:3000'
      }.freeze

      define host: 'travis-ci.org',
             redis: { url: 'redis://localhost:6379' },
             sentry: {},
             metrics: { reporter: 'librato' },
             sidekiq: { namespace: 'sidekiq', pool_size: 3 },
             ssl: {},
             pusher: {}

      default _access: [:key]

      def metrics
        super.to_h.merge(librato: librato.to_h.merge(source: librato_source))
      end

      def env
        Travis.env
      end

      def http_host
        "https://#{host}"
      end
    end
  end
end
