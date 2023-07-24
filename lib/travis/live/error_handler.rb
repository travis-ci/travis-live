# frozen_string_literal: true

require 'raven'

module Travis
  module Live
    class ErrorHandler
      def call(_worker, job, _queue)
        yield
      rescue StandardError => e
        Sidekiq.logger.warn(e)

        Raven.capture_exception(e, extra: { sidekiq: job }) if Travis.config.sentry.any?

        raise
      end
    end
  end
end
