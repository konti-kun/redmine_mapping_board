require 'database_cleaner'
require 'selenium/webdriver'
require File.expand_path(File.dirname(__FILE__) + '/../../../spec/rails_helper')
spec_type = Redmine::VERSION::MAJOR >= 4 ? :system : :feature

RSpec.configure do |config|
  config.before(:suite) do
    if Redmine::VERSION::MAJOR < 4
      DatabaseCleaner.strategy = :truncation
    end
  end
  config.before(:each) do |example|
    if Redmine::VERSION::MAJOR < 4
      DatabaseCleaner.start
    end
    if example.metadata[:type] == spec_type
      if example.metadata[:js]
        driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
      else
        driven_by :rack_test
      end
    end
  end
  config.after(:each) do
    if Redmine::VERSION::MAJOR < 4
      DatabaseCleaner.clean
    end
  end
  config.include FactoryBot::Syntax::Methods
  FactoryBot.definition_file_paths = [File.expand_path('../factories', __FILE__)]
  FactoryBot.find_definitions
  config.before(:all) do
    FactoryBot.reload
  end
end
