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
          payload = parse(payload)
          params = parse(params)

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

        def parse(input)
          if input.is_a?(Array) && input.length > 0
            input[0]
          elsif input.is_a?(String) && input.length > 0
            JSON.parse(input)
          else
            {}
          end
        end
      end
    end
  end
end
