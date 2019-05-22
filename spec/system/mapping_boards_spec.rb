require File.expand_path(File.dirname(__FILE__) + '/../rails_helper')
require File.expand_path(File.dirname(__FILE__) + '/helpers')
spec_type = Redmine::VERSION::MAJOR >= 4 ? :system : :feature

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe 'MappingBoard', type: spec_type do
  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers,
           :watchers, :journals, :journal_details, :versions

  before do
    log_user('admin', 'admin')
    set_mappingboards
  end

  describe "Initialize" do

    scenario "Mappingboad is created when user first shows mappingboard" do
      expect{
        click_link 'Mapping Board'
      }.to change{ Mappingboard.count }.from(0).to(1)
    end

    scenario "Mappingboad is not created when user shows mappingboard for the second time" do
      click_link 'Mapping Board'
      expect{
        click_link 'Mapping Board'
      }.not_to change{ Mappingboard.count }
    end

    scenario "Name of mappingboard is set 'default'" do
      click_link 'Mapping Board'
      expect(find(".board-tab")).to have_content 'default'
    end 
  end


end
