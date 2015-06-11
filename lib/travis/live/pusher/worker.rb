require 'sidekiq'

class Travis
  module Async
    module Sidekiq
      module Worker
        include Sidekiq::Worker

        def perform(uuid, target, method, *args)
          p [:perform, uuid, target, method, args]
          Travis.logger.info("Perform: " + [:perform, uuid, target, method, args].inspect)
        end
      end
    end
  end
end

class Travis::Async::Sidekiq::Worker
  module Live
    module Pusher
      class Worker
        include Sidekiq::Worker
        sidekiq_options retry: true, queue: 'pusher-live'

        def perform(uuid, target, method, *args)
          p [:perform, uuid, target, method, args]
          Travis.logger.info("Perform: " + [:perform, uuid, target, method, args].inspect)
        end
      end
    end
  end
end
