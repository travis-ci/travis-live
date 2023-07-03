require 'spec_helper'

describe Travis::Live::Pusher::Task do
  let(:payload) do
    { 'id' => 430_969,
      'repository_id' => 16_594,
      'repository_slug' => 'carlad/travis-ci-staging-test',
      'repository_private' => false, 'build_id' => 430_967,
      'commit_id' => 174_021,
      'log_id' => 401_827,
      'number' => '44.2',
      'state' => 'started',
      'started_at' => '2015-06-17T13:10:59Z',
      'finished_at' => nil,
      'queue' => 'builds.docker',
      'allow_failure' => false,
      'annotation_ids' => [],
      'commit' => { 'id' => 174_021,
                    'sha' => '9f3933c71e4a220c36b45f5b19e33ef1552c19c3',
                    'branch' => 'master',
                    'message' => 'pusher-live',
                    'committed_at' => '2015-06-17T12:41:17Z',
                    'author_name' => 'carlad',
                    'author_email' => 'carlad@users.noreply.github.com',
                    'committer_name' => 'carlad',
                    'committer_email' => 'carlad@users.noreply.github.com',
                    'compare_url' => 'https://github.com/carlad/travis-ci-staging-test/compare/633812825928...9f3933c71e4a' } }
  end

  let(:params) { { 'event' => 'job:test:started' } }

  describe 'trigger' do
    it 'assigns the correct channels' do
      task = Travis::Live::Pusher::Task.new(payload, params)
      task.channels.should == ['repo-16594']
    end

    it 'sends only an id if the job  payload is too big' do
      payload['commit']['message'] = 'a' * 10_240
      task = Travis::Live::Pusher::Task.new(payload, params)
      task.expects(:trigger).with(['repo-16594'], { id: 430_969, build_id: 430_967, _no_full_payload: true })
      task.run
    end

    it 'sends only an id if the job  payload is too big' do
      payload = {
        'build' => {
          'id' => 100
        },
        'commit' => {
          'message' => 'a' * 10_240
        },
        'repository' => {
          'id' => 1
        }
      }
      params = { 'event' => 'build:started' }
      task = Travis::Live::Pusher::Task.new(payload, params)
      task.expects(:trigger).with(['repo-1'], { build: { id: 100 }, _no_full_payload: true })
      task.run
    end

    context 'when user_ids were sent' do
      before do
        params.merge! user_ids: [1, 3]
      end

      context 'when config.pusher.secure? is set' do
        before do
          Travis.config.pusher.secure = true
        end

        it 'does not send to public (repo) channels' do
          task = Travis::Live::Pusher::Task.new(payload, params)
          task.channels.should == %w[private-user-1 private-user-3]
        end
      end

      it 'sends to user channels as well' do
        task = Travis::Live::Pusher::Task.new(payload, params)
        task.channels.should == %w[private-user-1 private-user-3 repo-16594]
      end

      it 'does not send to a repo channel when repository is private' do
        payload['repository_private'] = true
        task = Travis::Live::Pusher::Task.new(payload, params)
        task.channels.should == %w[private-user-1 private-user-3]
      end
    end

    it 'triggers a pusher event with the correct payload' do
      task = Travis::Live::Pusher::Task.new(payload, params)
      task.expects(:trigger).with(['repo-16594'], payload.deep_symbolize_keys)
      task.run
    end
  end
end
