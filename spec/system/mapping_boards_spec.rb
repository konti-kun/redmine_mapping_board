require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

RSpec.describe 'MappingBoard', type: :system do
  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers,
           :watchers, :journals, :journal_details, :versions

  before do

  end

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

  private
  def log_user(login, password)
    visit '/my/page'
    assert_equal '/login', current_path
    within('#login-form form') do
      fill_in 'username', :with => login
      fill_in 'password', :with => password
      find('input[name=login]').click
    end
    assert_equal '/my/page', current_path
  end

  def set_mappingboards()
    visit '/projects/ecookbook'
    click_link 'Settings'
    check 'project_enabled_module_names_mappingboards'
    click_button 'Save'
  end

end
