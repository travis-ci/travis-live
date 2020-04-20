# Travis::Live

Travis::Live is our central place for sending status update messages to pusher.

travis-scheduler, travis-hub, travis-gatekeeper, and travis-github-sync talk to it via the `Travis::Async::Sidekiq::Worker` class over sidekiq.

Live talks to pusher.

