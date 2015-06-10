require 'sidekiq'

class Travis::Async::Sidekiq::Worker
  include Sidekiq::Worker
  sidekiq_options retry: true, queue: 'pusher-live'

  def perform(uuid, target, method, *args)
    p [:perform, uuid, target, method, args]
    Travis.logger.info("Perform: " + [:perform, uuid, target, method, args].inspect)
  end
end
