set :bundle_without, %w{deployment test development}.join(' ')
set :deploy_host, "dorfetcher-prod"
server "#{fetch(:deploy_host)}.stanford.edu", user: fetch(:user), roles: %w{web db app}

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, 'production'
