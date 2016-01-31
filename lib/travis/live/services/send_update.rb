require 'travis/live'
require 'travis/live/helpers/metrics'
require 'travis/live/pusher/existence'

module Travis
  module Live
    module Services
      class SendUpdate
        include Helpers::Metrics

        def self.metriks_prefix
          'live.send_update'
        end

        attr_reader :payload, :params

        def initialize(payload, params = {})
          @payload = payload.deep_symbolize_keys
          @params  = params.deep_symbolize_keys
        end

        def run
          timeout after: params[:timeout] || 5 do
            trigger(channel, payload)
          end
        end

        def event
          params[:event]
        end

        def client_event
          @client_event ||= (event =~ /job:.*/ ? event.gsub(/(test|configure):/, '') : event)
        end

        def channel
          [channel_prefix, "repo-#{repo_id}"].compact.join('-')
        end

        private

          def trigger(channel_name, payload)
            if existence_check?
              if channel_occupied?(channel_name)
                mark('pusher.send')
              else
                mark('pusher.ignore')

                return if existence_check?
              end
            end

            measure('pusher') do
              Travis::Live.pusher[channel_name].trigger(client_event, payload)
            end
          rescue ::Pusher::Error => e
            Travis::Live.logger.error("error=Pusher::Error message=\"#{e.message}\" event=#{client_event} payload=\"#{part.inspect}\"")
            raise
          end

          def job_id
            payload[:id]
          end

          def repo_id
            # TODO api v1 is inconsistent here
            payload.key?(:repository) ? payload[:repository][:id] : payload[:repository_id]
          end

          def channel_prefix
            'private' if private_channels?
          end

          def private_channels?
            force_private_channels? || repository_private?
          end

          def public_channels?
            !private_channels?
          end

          def force_private_channels?
            Travis::Live.config.pusher.secure?
          end

          def channel_occupied?(channel_name)
            Travis::Live::Pusher::Existence.new.occupied?(channel_name)
          end

          def existence_check?
            Travis::Live.config.pusher.channels_existence_check?
          end

          def repository_private?
            payload.key?(:repository) ? payload[:repository][:private] : payload[:repository_private]
          end

          def timeout(options = { after: 60 }, &block)
            Timeout::timeout(options[:after], &block)
          end
      end
    end
  end
end
