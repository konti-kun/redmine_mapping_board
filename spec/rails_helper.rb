require 'database_cleaner'
require 'selenium/webdriver'
require File.expand_path(File.dirname(__FILE__) + '/../../../spec/rails_helper')
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do |example|
    DatabaseCleaner.start
    if example.metadata[:type] == :system
      if example.metadata[:js]
        driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
      else
        driven_by :rack_test
      end
    end
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
  config.include FactoryBot::Syntax::Methods
  FactoryBot.definition_file_paths = [File.expand_path('../factories', __FILE__)]
  FactoryBot.find_definitions
  config.before(:all) do
    FactoryBot.reload
  end
end
