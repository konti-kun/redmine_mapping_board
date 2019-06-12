require File.expand_path(File.dirname(__FILE__) + '/../rails_helper')
require File.expand_path(File.dirname(__FILE__) + '/helpers')
spec_type = Redmine::VERSION::MAJOR >= 4 ? :system : :feature

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe 'MappingIssue', type: spec_type do
  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers,
           :watchers, :journals, :journal_details, :versions

  before do
    log_user('admin', 'admin')
    set_mappingboards
  end

  let(:project){ Project.find(Mappingboard.first.project_id) }

  describe "Initialize" do
    scenario "Show mapping issues title" do
      click_link 'Mapping Issues'
      expect(page).to have_content 'Mapping Issues', count:2
    end
    scenario "Show mapping issues title" do
      click_link 'Mapping Issues'
      expect(page).to have_content 'Filter'
    end

  end

end
