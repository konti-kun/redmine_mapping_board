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
    click_link 'Mapping Issues'
  end

  let(:project){ Project.find(Mappingboard.first.project_id) }

  describe "Initialize contents" do

    scenario "Show mapping issues title" do
      # tab name and content's title
      expect(page).to have_content 'Mapping Issues', count:2
    end

    scenario "Show mapping issues filter" do
      expect(page).to have_content 'Filter'
      expect(page).to_not have_content 'Options'
    end
  end

  describe "Initialize mapping issues table" do
    scenario "show fixed table columns" do
      expect(find("thead")).to have_content('#') &
        have_content('Tracker') & have_content('Status') & have_content('Subject') 
    end

    scenario "show mappingboad's names" do
      create :mappingboard, project: Project.first, name: "BOARD1"
      click_link 'Mapping Issues'
      expect(find("thead")).to have_content('BOARD1')
    end
  end

end
