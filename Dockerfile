FROM ruby:2.4.2

LABEL maintainer Travis CI GmbH <support+travis-app-docker-images@travis-ci.com>

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile      /usr/src/app
COPY Gemfile.lock /usr/src/app

ARG SIDEKIQ_PRO_GEMSOURCE

RUN bundle config https://gems.contribsys.com/ $SIDEKIQ_PRO_GEMSOURCE
RUN bundle install --without test

RUN bundle config --delete https://gems.contribsys.com/

COPY . /usr/src/app

CMD bundle exec je sidekiq -c 25 -r ./lib/travis/live/pusher.rb -q pusher-live live
