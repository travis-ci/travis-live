FROM ruby:2.4.2

LABEL maintainer Travis CI GmbH <support+travis-live-docker-images@travis-ci.com>

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1;
RUN mkdir -p /app
WORKDIR /app

COPY Gemfile       /app
COPY Gemfile.lock  /app

ARG bundle_gems__contribsys__com
RUN bundle config https://gems.contribsys.com/ $bundle_gems__contribsys__com \
      && bundle install --without test \
      && bundle config --delete https://gems.contribsys.com/

# Copy app files into app folder
COPY . /app

CMD ["bundle", "exec", "je", "sidekiq", "-c 25", "-r ./lib/travis/live/pusher.rb", "-q pusher-live", "live"]