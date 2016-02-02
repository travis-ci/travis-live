require 'sidekiq'
require 'travis/live/services/send_update'

module Travis
  module Live
    module Sidekiq
      class Worker
        include ::Sidekiq::Worker
        sidekiq_options :retry => 3, :dead => false

        def perform(uuid, target, method, payload, params)
          Travis::Live::Services::SendUpdate.new(payload, params).run
        end
      end
    end
  end

  module Async
    module Sidekiq
      Worker = Travis::Live::Sidekiq::Worker
    end
  end
end
