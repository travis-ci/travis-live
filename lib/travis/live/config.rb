require 'travis/config'

module Travis
  module Live
    class Config < Travis::Config
      define host:    "localhost",
             redis:   { url: "redis://localhost:6379" },
             sentry:  { },
             metrics: { reporter: 'librato' },
             sidekiq: { namespace: "sidekiq", pool_size: 3 },
             ssl:     { },
             pusher:  { secure: false }

      default _access: [:key]

      def env
        Travis::Live.env
      end

      def http_host
        "https://#{host}"
      end
    end
  end
end
