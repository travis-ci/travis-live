# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

gem 'sidekiq-pro', source: 'https://gems.contribsys.com'

gem 'activesupport', '~> 7'
gem 'travis-config', path: '~/tmp/travis-config' # '~> 1.0.3'
gem 'travis-exceptions', path: '~/tmp/travis-exceptions' # github: 'travis-ci/travis-exceptions'
gem 'travis-metrics',    path: '~/tmp/travis-metrics' # github: 'travis-ci/travis-metrics'
gem 'travis-support',    path: '~/tmp/travis-support' # github: 'travis-ci/travis-support'

gem 'metriks',                 git: 'https://github.com/travis-ci/metriks'
gem 'metriks-librato_metrics', git: 'https://github.com/travis-ci/metriks-librato_metrics'

gem 'redis-namespace'

gem 'jemalloc'

gem 'multi_json'
gem 'pusher', '~> 2.0.3'
gem 'rollout', github: 'jamesgolick/rollout', ref: 'v1.1.0'
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
