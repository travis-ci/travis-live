require 'metriks'

module Travis
  module Live
    module Middleware
      class Metriks
        def call(worker, message, queue, &block)
          begin
            ::Metriks.meter("travis-live.jobs.#{queue}").mark
            ::Metriks.timer("travis-live.jobs.#{queue}.perform").time(&block)

            _, _, _, _, params = *message['args']
            if event = params['event']
              event = event.gsub(':', '-')
              ::Metriks.meter("travis-live.events.#{event}").mark
            end
          rescue Exception
            ::Metriks.meter("travis-live.jobs.#{queue}.failure").mark
            raise
          end
        end
      end
    end
  end
end
