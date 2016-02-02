live: bundle exec je sidekiq -c 25 -r ./lib/travis/live/initializers/sidekiq.rb -q live-updates -q pusher-live
web:  bundle exec je puma -I lib -p $PORT -t ${PUMA_MIN_THREADS:-8}:${PUMA_MAX_THREADS:-12}
