# frozen_string_literal: true

require 'active_support/core_ext/benchmark'

module Travis
  module Live
    module Middleware
      class Logging
        def call(_worker, message, queue, &block) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
          time = Benchmark.ms(&block)
        ensure
          uuid, _, _, payload, params = *message['args']
          if payload.is_a?(Array) && payload.length > 0
            payload = payload[0]
            params = params[0]
          end
          payload = JSON.parse(payload) if payload.is_a?(String) && payload.length > 0
          params = JSON.parse(params) if params.is_a?(String) && params.length > 0
          out_data = {}.tap do |data|
            data['type'] = queue
            if payload['build']
              data['build'] = payload['build']['id']
            elsif message['build_id']
              data['build'] = payload['build_id']
            end

            data['repo'] = payload['repository']['slug'] if payload['repository']

            data['event'] = params['event'] if params['event']
            data['uuid'] = uuid
            data['job'] = payload['id'] if params['event'] && params['event'] =~ /^job/
            data['time'] = format('%.3f', (time / 1000)) if time
            data['jid'] = message['jid']
          end
          log(out_data)
        end

        def log(data)
          line = "event=#{data['event']}"
          line << " build=#{data['build']}" if data['build']
          line << " job=#{data['job']}" if data['job']
          line << " uuid=#{data['uuid']}"
          line << " jid=#{data['jid']}"
          line << " time=#{data['time']}" if data['time']
          Travis.logger.info(line)
        end
      end
    end
  end
end
