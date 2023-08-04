# frozen_string_literal: true

require 'metriks'

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
          payload = JSON.parse(payload) if payload.is_a?(String)
          @payload = payload.deep_symbolize_keys
          @params  = params.deep_symbolize_keys
        end

        def run
          ::Metriks.meter("travis-live.events.#{event}").mark
          timeout after: params[:timeout] || 60 do
            process
          end
        end

        def event
          params[:event]
        end

        def type
          event.split(':')[0]
        end

        def user_ids
          params[:user_ids] || []
        end

        def client_event
          @_client_event ||= (/job:.*/.match?(event) ? event.gsub(/(test|configure):/, '') : event)
        end

        def channels
          channels = user_ids.map { |id| "private-user-#{id}" }

          channels << "repo-#{repo_id}" if public_channels?

          channels
        end

        private

        def process
          payload_to_process = prepare_payload(payload)
          channels.each_slice(10) { |channels_part| trigger(channels_part, payload_to_process) }
        end

        def prepare_payload(payload)
          encoded_payload = MultiJson.encode(payload)
          if encoded_payload.length > 10_000
            if type == 'job'
              { id: payload[:id], build_id: payload[:build_id], _no_full_payload: true }
            elsif type == 'build'
              { build: { id: payload[:build][:id] }, _no_full_payload: true }
            else
              payload
            end
          else
            payload
          end
        end

        def trigger(channels, payload)
          Travis.pusher.trigger(channels, client_event, payload)
        rescue ::Pusher::Error => e
          Travis.logger.error("[addons:pusher] Could not send event due to Pusher::Error: #{e.message}, event=#{client_event}, payload: #{payload.inspect}")
          raise
        end

        def job_id
          payload[:id]
        end

        def repo_id
          # TODO: api v1 is inconsistent here
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
          Timeout.timeout(options[:after], &block)
        end
      end
    end
  end
end
