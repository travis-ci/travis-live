FROM ruby:2.4.2

LABEL maintainer Travis CI GmbH <support+travis-app-docker-images@travis-ci.com>

# required for envsubst tool
RUN ( \
   apt-get update ; \
   apt-get install -y --no-install-recommends  gettext-base; \
   rm -rf /var/lib/apt/lists/* \
)

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# Create app folder
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile       /usr/src/app
COPY Gemfile.lock  /usr/src/app

ARG bundle_gems__contribsys__com
RUN bundle config https://gems.contribsys.com/ $bundle_gems__contribsys__com \
      && bundle install --without test \
      && bundle config --delete https://gems.contribsys.com/

# Copy app files into app folder
COPY . /usr/src/app

CMD bundle exec je sidekiq -c 25 -r ./lib/travis/live/pusher.rb -q pusher-live live