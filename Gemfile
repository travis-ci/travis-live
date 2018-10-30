source 'https://rubygems.org'

ruby '2.4.2'

gem 'sidekiq-pro', source: 'https://gems.contribsys.com'

gem 'activesupport',     '~> 4.2.5'
gem 'travis-config',     '~> 1.0.3'
gem 'travis-exceptions', git: 'https://github.com/travis-ci/travis-exceptions'
gem 'travis-support',    git: 'https://github.com/travis-ci/travis-support'
gem 'travis-metrics',    git: 'https://github.com/travis-ci/travis-metrics'

gem 'metriks',                 git: 'https://github.com/travis-ci/metriks'
gem 'metriks-librato_metrics', git: 'https://github.com/travis-ci/metriks-librato_metrics'

gem 'redis-namespace'

gem 'jemalloc',         git: 'https://github.com/joshk/jemalloc-rb'

gem 'sentry-raven'
gem 'rollout',          git: 'https://github.com/jamesgolick/rollout', :ref => 'v1.1.0'
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
