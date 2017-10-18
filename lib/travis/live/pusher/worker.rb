require 'sidekiq'
require 'travis/live/pusher/task'

module Travis
  module Async
    module Sidekiq
      class Worker
        include ::Sidekiq::Worker

        sidekiq_options dead: false

        def perform(uuid, target, method, payload, params)
          Travis::Live::Pusher::Task.new(payload, params).run
        end
      end
    end
  end
end
