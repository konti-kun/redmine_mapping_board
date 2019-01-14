Redmine::Plugin.register :ticket_mapping do
  name 'Ticket Mapping plugin'
  author 'konti-kun'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/konti-kuni'
  author_url 'https://github.com/konti-kun'

  permission :maps, {:maps => [:index]}, :public => true
  menu :project_menu, :maps, { :controller => 'maps', :action => 'index' }, :caption => 'Maps', :after => :activity, :param => :project_id
end
