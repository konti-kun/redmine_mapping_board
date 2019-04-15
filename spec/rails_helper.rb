require File.expand_path(File.dirname(__FILE__) + '/../../../spec/rails_helper')
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  FactoryBot.definition_file_paths = [File.expand_path('../factories', __FILE__)]
  FactoryBot.find_definitions
  config.before(:all) do
    FactoryBot.reload
  end
end
