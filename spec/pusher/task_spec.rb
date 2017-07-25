require 'spec_helper'

describe Travis::Live::Pusher::Task do

  let(:payload) { { "id"=>430969,
                    "repository_id"=>16594,
                    "repository_slug"=>"carlad/travis-ci-staging-test",
                    "repository_private"=>false, "build_id"=>430967,
                    "commit_id"=>174021,
                    "log_id"=>401827,
                    "number"=>"44.2",
                    "state"=>"started",
                    "started_at"=>"2015-06-17T13:10:59Z",
                    "finished_at"=>nil,
                    "queue"=>"builds.docker",
                    "allow_failure"=>false,
                    "annotation_ids"=>[],
                    "commit"=>{"id"=>174021,
                    "sha"=>"9f3933c71e4a220c36b45f5b19e33ef1552c19c3",
                    "branch"=>"master",
                    "message"=>"pusher-live",
                    "committed_at"=>"2015-06-17T12:41:17Z",
                    "author_name"=>"carlad",
                    "author_email"=>"carlad@users.noreply.github.com",
                    "committer_name"=>"carlad",
                    "committer_email"=>"carlad@users.noreply.github.com",
                    "compare_url"=>"https://github.com/carlad/travis-ci-staging-test/compare/633812825928...9f3933c71e4a" } } }

  let(:params) { { "event"=>"job:test:started" } }

  describe 'trigger' do
    it 'assigns the correct channels' do
      task = Travis::Live::Pusher::Task.new(payload, params)
      task.channels.should == ["repo-16594"]
    end

    context 'when user_ids were sent' do
      before do
        params.merge! user_ids: [1, 3]
      end

      it 'sends to user channels as well' do
        task = Travis::Live::Pusher::Task.new(payload, params)
        task.channels.should == ["user-1", "user-3", "repo-16594"]
      end

      it 'does not send to a repo channel when repository is private' do
        payload['repository_private'] = true
        task = Travis::Live::Pusher::Task.new(payload, params)
        task.channels.should == ["private-user-1", "private-user-3"]
      end
    end

    it 'triggers a pusher event with the correct payload' do
      task = Travis::Live::Pusher::Task.new(payload, params)
      task.expects(:trigger).with(["repo-16594"], payload.deep_symbolize_keys)
      task.run
    end
  end

end
