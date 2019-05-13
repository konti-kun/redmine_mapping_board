module Helpers
  def log_user(login, password)
    visit '/my/page'
    if  '/login' == current_path
      within('#login-form form') do
        fill_in 'username', with: login
        fill_in 'password', with: password
        find('input[name=login]').click
      end
    end
    assert_equal '/my/page', current_path
  end

  def set_mappingboards()
    visit '/projects/ecookbook'
    click_link 'Settings'
    if Redmine::VERSION::MAJOR < 4
      click_link 'Modules'
    end
    check 'Mappingboards'
    click_button 'Save'
  end
end
