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

    scenario "show checkbox in table" do
      create :mappingboard, project: Project.first, name: "BOARD1"
      click_link 'Mapping Issues'
      expect(find("tbody")).to have_selector '.checkbox', count: 10
    end

    scenario "show no checked cell in table" do
      create :mappingboard, project: Project.first, name: "BOARD1"
      click_link 'Mapping Issues'
      expect(find("tbody")).to_not have_selector '.icon-checked'
    end
  end

  describe "bulk create notes in the table", js: true do
    scenario "create 1 note" do
      create :mappingboard, project: Project.first, name: "BOARD1"
      click_link 'Mapping Issues'
      check "issue_#{Mappingboard.first.id}_#{Issue.where(project_id: Project.first).first.id}"
      expect{
        click_link 'new_notes_btn'
        click_link 'Mapping Issues'
      }.to(
        change{ Note.count }.from(0).to(1)
      )
    end

    scenario "create 2 notes" do
      create :mappingboard, project: Project.first, name: "BOARD1"
      click_link 'Mapping Issues'
      check "issue_#{Mappingboard.first.id}_#{Issue.where(project_id: Project.first, status:1).first.id}"
      check "issue_#{Mappingboard.first.id}_#{Issue.where(project_id: Project.first, status:1).last.id}"
      expect{
        click_link 'new_notes_btn'
        click_link 'Mapping Issues'
      }.to(
        change{ Note.count }.from(0).to(2)
      )
    end

    describe "When issue has been used yet, " do
      before do
        board = create :mappingboard, project: Project.first, name: "BOARD1"
        click_link 'Mapping Issues'
        create :note, issue: Issue.where(project_id: Project.first, status:1).first, mappingboard: board
        check "issue_#{Mappingboard.first.id}_#{Issue.where(project_id: Project.first).first.id}"
        check "issue_#{Mappingboard.first.id}_#{Issue.where(project_id: Project.first, status:1).last.id}"
      end

      scenario "rollback data" do
        expect{
          click_link 'new_notes_btn'
          click_link 'Mapping Issues'
        }.to_not (
          change{ Note.count }
        )
      end
      scenario "show rollback message" do
        click_link 'new_notes_btn'
        expect(page).to have_content "The issue has be used yet, please select another issue."
      end
    end

  end

end
