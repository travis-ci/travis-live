require 'spec_helper'
require 'ostruct'
require 'travis/live/web/app'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

describe Travis::Live::Web::App do
  include Rack::Test::Methods

  let(:app)       { described_class.new(nil, pusher) }
  let(:pusher)    { mock() }
  let(:existence) { Travis::Live::Pusher::Existence.new }

  before do
    existence.vacant!('foo')
    existence.vacant!('bar')
  end

  describe 'GET /uptime' do
    it 'returns 204' do
      response = get '/uptime'
      response.status.should == 204
    end
  end

  describe 'POST /pusher/existence' do
    it 'sets proper properties on channel' do
      existence.occupied?('foo').should be_false
      existence.occupied?('bar').should be_false

      webhook = OpenStruct.new(valid?: true, events: [
        { 'name' => 'channel_occupied', 'channel' => 'foo' },
        { 'name' => 'channel_vacated',  'channel' => 'bar' }
      ])
      pusher.expects(:webhook).with() { |request|
        request.path_info == '/pusher/existence'
      }.returns(webhook)

      response = post '/pusher/existence'
      response.status.should == 204

      existence.occupied?('foo').should be_true
      existence.occupied?('bar').should be_false

      webhook = OpenStruct.new(valid?: true, events: [
        { 'name' => 'channel_vacated', 'channel' => 'foo' },
        { 'name' => 'channel_occupied', 'channel' => 'bar' }
      ])
      pusher.expects(:webhook).with() { |request|
        request.path_info == '/pusher/existence'
      }.returns(webhook)

      response = post '/pusher/existence'
      response.status.should == 204

      existence.occupied?('foo').should be_false
      existence.occupied?('bar').should be_true
    end

    it 'responds with 401 with invalid webhook' do
      webhook = OpenStruct.new(valid?: false)
      pusher.expects(:webhook).with() { |request|
        request.path_info == '/pusher/existence'
      }.returns(webhook)

      response = post '/pusher/existence'
      response.status.should == 401
    end
  end
end
