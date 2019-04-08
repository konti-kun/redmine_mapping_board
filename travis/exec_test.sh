#! /bin/sh


export REDMINE_LANG=ja
export RAILS_ENV=test

# Initialize redmine
bundle exec rake generate_secret_token
bundle exec rake db:migrate
bundle exec rake redmine:load_default_data

# Copy assets & execute plugin's migration
bundle exec rake redmine:plugins NAME=redmine_mapping_board

# Initialize RSpec
bundle exec rails g rspec:install
sed -i -e "s#/spec/fixtures#/test/fixtures#g" spec/rails_helper.rb

# Execute test by RSpec
bundle exec rspec plugins/redmine_mapping_board/spec -c
