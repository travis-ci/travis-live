require 'redis'
require 'travis/live/helpers/redis_pool'

module Travis
  module Live
    module Pusher
      class Existence
        attr_reader :redis

        def initialize(redis = Helpers::RedisPool.new)
          @redis = redis
        end

        def occupied!(channel_name)
          key = self.key(channel_name)
          redis.set(key, true)
          redis.expire(key, 6 * 3600)
        end

        def occupied?(channel_name)
          redis.get(key(channel_name))
        end

        def vacant?(channel_name)
          !occupied?(channel_name)
        end

        def vacant!(channel_name)
          redis.del(key(channel_name))
        end

        def key(channel_name)
          "live:channel-occupied:#{channel_name}"
        end
      end
    end
  end
end
