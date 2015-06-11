require 'sidekiq'

module Travis
  module Async
    module Sidekiq
      class Worker
        include ::Sidekiq::Worker

        def perform(uuid, target, method, *args)
          p [:perform, uuid, target, method, args]
          Travis.logger.info("Perform: " + [:perform, uuid, target, method, args].inspect)
        end
      end
    end
  end
end
