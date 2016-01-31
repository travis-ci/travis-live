require 'sidekiq'
require 'travis/live/services/send_update'

module Travis
  module Live
    module Sidekiq
      class Worker
        include ::Sidekiq::Worker

        def perform(uuid, target, method, payload, params)
          Travis::Live::Services::SendUpdate.new(payload, params).run
        end
      end
    end
  end
end

Travis.const_set("Async::Sidekiq::Worker", Travis::Live::Sidekiq::Worker)
