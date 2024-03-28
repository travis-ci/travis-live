# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

gem 'sidekiq-pro', source: 'https://gems.contribsys.com'
gem 'sidekiq', '~> 7.2.0'

gem 'activesupport', '~> 7'
gem 'travis-config', git: 'https://github.com/travis-ci/travis-config'
gem 'travis-exceptions', git: 'https://github.com/travis-ci/travis-exceptions'
gem 'travis-metrics',    git: 'https://github.com/travis-ci/travis-metrics'
gem 'travis-support',   git: 'https://github.com/travis-ci/travis-support'

gem 'metriks',                 git: 'https://github.com/travis-ci/metriks'
gem 'metriks-librato_metrics', git: 'https://github.com/travis-ci/metriks-librato_metrics'

gem 'redis'
gem 'redis-namespace'
gem 'rake', '~> 13.0.6'

gem 'jemalloc', git: 'https://github.com/travis-ci/jemalloc-rb', branch: 'jemalloc-v-3-new-rake'

gem 'multi_json'
gem 'pusher', '~> 2.0.3'
gem 'rollout', git: 'https://github.com/travis-ci/rollout'
gem 'sentry-ruby'

group :development, :test do
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
  gem 'simplecov'
  gem 'simplecov-console'
end

group :test do
  gem 'guard'
  gem 'guard-rspec'
  gem 'mocha', '~> 2.0.4'
  gem 'rspec', '~> 3.12.0'
  gem 'webmock', '~> 3.18.1'
end

group :production do
  gem 'foreman'
end
