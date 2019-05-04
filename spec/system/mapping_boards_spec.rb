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


  scenario "Administrator can set mapping board module for a project" do
    log_user('admin', 'admin')
    set_mappingboards
    expect(page).to have_content 'Mapping Board'
  end

  scenario "Show mappingboard at first time" do
    log_user('admin', 'admin')
    set_mappingboards
    expect(Mappingboard.exists?).to be_falsey
    click_link 'Mapping Board'
    project = Project.find(Mappingboard.first.project_id)
    expect(project.name).to eq "eCookbook"
  end

end
