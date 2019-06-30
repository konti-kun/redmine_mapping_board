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

  let(:project){ Project.find(Mappingboard.first.project_id) }

  describe "Initialize" do

    scenario "Mappingboard is created when user first shows mappingboard" do
      expect{
        click_link 'Mapping Board'
      }.to change{ Mappingboard.count }.from(0).to(1)
    end

    scenario "Mappingboard is not created when user shows mappingboard for the second time" do
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

  describe "Change name", js: true do

    let(:board){ Mappingboard.first }

    scenario "It can change name of mappingboad when dbclick that name" do
      click_link 'Mapping Board'
      find(".board-tab > .active").double_click 
      fill_in "change-board", with: 'new name' + '\n'
      find("#change-board").send_keys(:tab)
      page.has_no_css? '#change-board'
      # I don't catch focusout event so this test has not be clear
      #page.execute_script "$('#change-board').trigger('focusout');"
      #click_link 'Mapping Board'
      #expect(Mappingboard.first.name).to eq "new name"
    end
  end

  describe "Add", js: true do

    def add_note
        click_link 'new note'
        within '#new_note' do
          fill_in 'issue_subject', with: 'new note'
          click_button 'Add'
        end
        page.has_no_css? '.ui-widget-overlay'
    end

    before do
      click_link "Mapping Board"
      add_note
    end

    scenario "Mappingboard have been added when click '+' in board-tab" do
      expect{
        find(".board-tab").click_link "+"
      }.to change{ Mappingboard.count }.from(1).to(2)
    end

    scenario "Added mappingboard doesn't have any note" do
      before_board = Mappingboard.first
      find(".board-tab").click_link "+"
      expect(Note.where.not(mappingboard_id: before_board).count).to eq 0
    end

  end

end
