require File.expand_path(File.dirname(__FILE__) + '/../rails_helper')
spec_type = Redmine::VERSION::MAJOR >= 4 ? :system : :feature

require 'system/helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe 'Notes', type: spec_type do
  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers,
           :watchers, :journals, :journal_details, :versions

  before do
    log_user('admin', 'admin')
    set_mappingboards
    click_link 'Mapping Board'
  end

  scenario "Show mappingboard at first time", js: true do
    expect(page).to have_no_selector '.notes > g'
  end

  describe "Click 'new note'" do
    before do
      click_link 'new note'
    end
      
    scenario "Show modal diag at first time", js: true do
      expect(page).to have_selector '.modal'
      expect(page).to have_selector '.ui-dialog-titlebar > span', text: 'select issue'
    end

    scenario "Select existed issue on modal diag", js: true do
      within '#new_note' do
        fill_in 'issue_id', with: '2'
        click_button 'Apply'
        expect(page).to have_select 'issue_tracker_id', selected: 'Feature request'
        expect(page).to have_field 'issue_subject', with: 'Add ingredients categories'
      end
    end
  end

  describe "Add new note" do
    before do
      click_link 'new note'
    end

    scenario "Select existed issue and add note", js: true do
      within '#new_note' do
        fill_in 'issue_id', with: '2'
        click_button 'Apply'
        click_button 'Add'
      end
      expect(page).to have_selector '.notes > g', count: 1
      note_node = find '.note'
      expect(note_node[:transform]).to eq 'translate(0,0)'
      expect(page).to have_selector '.notes > g a', text: '#2'
    end

  end

end
