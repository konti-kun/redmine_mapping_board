require File.expand_path(File.dirname(__FILE__) + '/../rails_helper')
require File.expand_path(File.dirname(__FILE__) + '/helpers')
spec_type = Redmine::VERSION::MAJOR >= 4 ? :system : :feature

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

  let(:project){ Project.find(Mappingboard.first.project_id) }

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

    let(:note_node){ find '.note'}

    scenario "Select existed issue", js: true do
      within '#new_note' do
        fill_in 'issue_id', with: '2'
        click_button 'Apply'
        click_button 'Add'
      end
      expect(note_node[:transform]).to eq 'translate(0,0)'
      expect(note_node).to have_link '#2'
    end

    scenario "No input issue no", js: true do
      latest_issue_no = Issue.last.id

      within '#new_note' do
        fill_in 'issue_subject', with: 'new note'
        click_button 'Add'
      end
      expect(note_node[:transform]).to eq 'translate(0,0)'
      expect(note_node).to have_link '#' + (latest_issue_no+1).to_s
    end
  end

  describe "Move note" do
    before do
      @issue = create :issue, project: project, tracker: project.trackers.first
    end

    def get_translate(translate)
      translate.match(/translate\(\s*([+-]?[0-9]+[\.]?[0-9]*),\s*([+-]?[0-9]+[\.]?[0-9]*)\)/)
    end

    let(:note_node){ find '.note'}

    context "Change the position of note" do
      before do
        create :note, issue: @issue, mappingboard: Mappingboard.first
        click_link 'Mapping Board'
      end

      subject {
        -> { 
          page.driver.browser.action.drag_and_drop_by(note_node.native, 100, 200).perform
          sleep 0.5
        }
      }

      scenario "And move the node of the note", js: true do
        is_expected.to change{ note_node[:transform] }.from('translate(0,0)').to('translate(100,200)')
      end

      scenario "And change the position data of the note model", js: true do
        is_expected.to change{ Note.first.x }.from(0).to(100).and change{ Note.first.y }.from(0).to(200)
      end

    end

    scenario "Move note when the window is refleshed", js: true do
      create :note, issue: @issue, mappingboard: Mappingboard.first, x: 10, y: 20
      click_link 'Mapping Board'
      expect{sleep 1}.to(
        change{ get_translate(note_node[:transform])[1].to_i }.from(0).to(10) &
        change{ get_translate(note_node[:transform])[2].to_i }.from(0).to(20)
      )
    end
  end

end
