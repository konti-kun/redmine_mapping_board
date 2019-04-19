#! /bin/sh

PLUGIN_NAME="redmine_mapping_board"

wget http://www.redmine.org/releases/redmine-${REDMINE_VERSION}.tar.gz
tar zxf redmine-${REDMINE_VERSION}.tar.gz

# Copy plugin files to plugin directory
mkdir redmine-${REDMINE_VERSION}/plugins/${PLUGIN_NAME}
mv app      redmine-${REDMINE_VERSION}/plugins/${PLUGIN_NAME}/app
mv assets   redmine-${REDMINE_VERSION}/plugins/${PLUGIN_NAME}/assets
mv config   redmine-${REDMINE_VERSION}/plugins/${PLUGIN_NAME}/config
mv db       redmine-${REDMINE_VERSION}/plugins/${PLUGIN_NAME}/db
mv lib      redmine-${REDMINE_VERSION}/plugins/${PLUGIN_NAME}/lib
mv spec     redmine-${REDMINE_VERSION}/plugins/${PLUGIN_NAME}/spec
mv Gemfile  redmine-${REDMINE_VERSION}/plugins/${PLUGIN_NAME}/Gemfile
mv test     redmine-${REDMINE_VERSION}/plugins/${PLUGIN_NAME}/test
mv init.rb  redmine-${REDMINE_VERSION}/plugins/${PLUGIN_NAME}/init.rb

# Create necessary files
cat > redmine-${REDMINE_VERSION}/config/database.yml <<_EOS_
test:
  adapter: sqlite3
  database: db/redmine_test.db
_EOS_

mv redmine-${REDMINE_VERSION}/* .
