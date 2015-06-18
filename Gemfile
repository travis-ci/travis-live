source 'https://rubygems.org'

ruby '2.2.2' if ENV.key?('DYNO')

gem 'activesupport',   '~> 3.2.12'
gem 'travis-support',  github: 'travis-ci/travis-support'
gem 'travis-config',  '~> 0.1.0'
gem 'unlimited-jce-policy-jdk7', github: 'travis-ci/unlimited-jce-policy-jdk7'

gem 'sidekiq',         '~> 2.17.0'
gem 'sentry-raven'
gem 'rollout',         github: 'jamesgolick/rollout', :ref => 'v1.1.0'
gem 'metriks'
gem 'metriks-librato_metrics'
gem 'multi_json'
gem 'pusher', '~> 0.14.5'

group :test do
  gem 'rspec',        '~> 2.14.0'
  gem 'mocha',        '~> 0.10.0'
  gem 'webmock',      '~> 1.8.0'
  gem 'guard'
  gem 'guard-rspec'
end

group :production do
  gem 'foreman'
end
