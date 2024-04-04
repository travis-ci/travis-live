source 'https://rubygems.org'

ruby '2.7.5'

gem 'sidekiq-pro', source: 'https://gems.contribsys.com'
gem 'sidekiq', '~> 6.4.0'

gem 'activesupport',     '~> 5.2.6.1'
gem 'travis-config',     '~> 1.0.3'
gem 'travis-exceptions', github: 'travis-ci/travis-exceptions'
gem 'travis-support',    github: 'travis-ci/travis-support'
gem 'travis-metrics',    github: 'travis-ci/travis-metrics'

gem 'metriks',                 git: 'https://github.com/travis-ci/metriks'
gem 'metriks-librato_metrics', git: 'https://github.com/travis-ci/metriks-librato_metrics'

gem 'redis', '~> 4.3.0'
gem 'redis-namespace', '~> 1.8.1'
gem 'rake', '~> 13.0.6'

gem 'jemalloc', git: 'https://github.com/travis-ci/jemalloc-rb', branch: 'jemalloc-v-3-new-rake'

gem 'sentry-raven'
gem 'rollout',          github: 'jamesgolick/rollout', :ref => 'v1.1.0'
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
