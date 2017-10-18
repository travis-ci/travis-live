source 'https://rubygems.org'

ruby '2.4.1'

gem 'sidekiq-pro', source: 'https://gems.contribsys.com'

gem 'activesupport',    '~> 4.2.5'
gem 'travis-support',   github: 'travis-ci/travis-support'
gem 'travis-config',    '~> 1.0.3'

gem 'redis-namespace'

gem 'jemalloc'

gem 'sentry-raven'
gem 'rollout',          github: 'jamesgolick/rollout', :ref => 'v1.1.0'
gem 'metriks'
gem 'metriks-librato_metrics'
gem 'multi_json'
gem 'pusher',           '~> 0.15.1'

group :test do
  gem 'rspec',          '~> 2.14.0'
  gem 'mocha',          '~> 0.10.0'
  gem 'webmock',        '~> 1.8.0'
  gem 'guard'
  gem 'guard-rspec'
end

group :production do
  gem 'foreman'
end
