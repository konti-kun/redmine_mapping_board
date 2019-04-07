require 'selenium/webdriver'
require File.expand_path(File.dirname(__FILE__) + '/../../../spec/spec_helper')
RSpec.configure do |config|
  config.before(:each) do |example|
    if example.metadata[:type] == :system
      if example.metadata[:js]
        driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
      else
        driven_by :rack_test
      end
    end
  end
end
