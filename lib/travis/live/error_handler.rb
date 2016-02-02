require 'raven'

module Travis
  module Live
    class ErrorHandler
      def call(worker, job, queue)
        yield
      rescue => ex
        Travis::Live.logger.warn(ex)

        if Travis::Live.config.sentry.any?
          Raven.capture_exception(ex, extra: {sidekiq: job})
        end

        raise
      end
    end
  end
end
