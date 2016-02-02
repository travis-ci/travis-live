require 'travis/live/config'
require 'travis/live/helpers/redis_pool'
require 'logger'
require 'pusher'

module Travis
  module Live
    class << self
      def config
        @config ||= Live::Config.load
      end

      def pusher
        @pusher ||= ::Pusher.tap do |pusher|
          pusher.scheme = config.pusher.scheme if config.pusher.scheme
          pusher.host   = config.pusher.host   if config.pusher.host
          pusher.port   = config.pusher.port   if config.pusher.port
          pusher.app_id = config.pusher.app_id
          pusher.key    = config.pusher.key
          pusher.secret = config.pusher.secret
        end
      end

      def redis_pool
        @redis_pool ||= Helpers::RedisPool.new(config.redis.to_hash)
      end

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

  class << self
    def config
      Live.config
    end

    def logger
      Live.logger
    end
  end
end
