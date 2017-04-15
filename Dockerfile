FROM ruby:2.3.4

LABEL maintainer Travis CI GmbH <support+travis-app-docker-images@travis-ci.com>

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile      /usr/src/app
COPY Gemfile.lock /usr/src/app

RUN bundle install --without test

COPY . /usr/src/app

CMD bundle exec je sidekiq -c 25 -r ./lib/travis/live/pusher.rb -q pusher-live live
