module Travis
  module Live
    module Pusher
      class Task
        class << self
          def perform(*args)
            new(*args).run
          end
        end

        attr_reader :payload, :params

        def initialize(payload, params = {})
          @payload = payload.deep_symbolize_keys
          @params  = params.deep_symbolize_keys
        end

        def run
          timeout after: params[:timeout] || 60 do
            process
          end
        end

        def event
          params[:event]
        end

        def user_ids
          params[:user_ids]
        end

        def client_event
          @client_event ||= (event =~ /job:.*/ ? event.gsub(/(test|configure):/, '') : event)
        end

        def channels
          channels = []
          if user_ids
            user_channels = user_ids.map { |id| "user-#{id}" }
            channels.push *user_channels
          else
            channels << "repo-#{repo_id}"
          end
          channels << "common" if public_channels? && !Travis.config.pusher.disable_common_channel?
          channels.map { |channel| [channel_prefix, channel].compact.join('-') }
        end

        private

          def process
            trigger(channels, payload)
          end

          def trigger(channels, payload)
            Travis.pusher.trigger(channels, client_event, payload)
          rescue ::Pusher::Error => e
            Travis.logger.error("[addons:pusher] Could not send event due to Pusher::Error: #{e.message}, event=#{client_event}, payload: #{part.inspect}")
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
            Travis.config.pusher.secure?
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
