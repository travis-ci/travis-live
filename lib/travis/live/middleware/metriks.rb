require 'metriks'

module Travis
  module Live
    module Middleware
      class Metriks
        def call(worker, message, queue, &block)
          begin
            ::Metriks.meter("travis-live.jobs.#{queue}").mark
            ::Metriks.timer("travis-live.jobs.#{queue}.perform").time(&block)
          rescue Exception
            ::Metriks.meter("travis-live.jobs.#{queue}.failure").mark
            raise
          end
        end
      end
    end
  end
end
