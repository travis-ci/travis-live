require 'sidekiq'

class PusherTask
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

  def client_event
    @client_event ||= (event =~ /job:.*/ ? event.gsub(/(test|configure):/, '') : event)
  end

  def channels
    channels = private_channels? ? ["repo-#{repo_id}"] : ['common']
    channels.map { |channel| [channel_prefix, channels].compact.join('-') }
  end

  private

    def process
      channels.each { |channel| trigger(channel, payload) }
    end

    def trigger(channel, payload)
      Travis.pusher[channel].trigger(client_event, payload)
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

module Travis
  module Async
    module Sidekiq
      class Worker
        include ::Sidekiq::Worker

        def perform(uuid, target, method, payload, params)
          Travis.logger.info("Perform: " + [:perform, uuid, target, method, payload, params].inspect)
          PusherTask.new(payload, params).run
        end
      end
    end
  end
end
