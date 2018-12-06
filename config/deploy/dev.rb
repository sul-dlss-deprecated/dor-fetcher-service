# frozen_string_literal: true

set :bundle_without, %w[deployment test].join(' ')
server 'dorfetcher-dev.stanford.edu', user: 'lyberadmin', roles: %w[web db app]

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, 'development'
