Redmine::Plugin.register :redmine_ticket_mapping do
  name 'Ticket Mapping plugin'
  author 'konti-kun'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/konti-kuni'
  author_url 'https://github.com/konti-kun'

  require_dependency 'qrcode_pdf'
  require_dependency 'mapping_hooks'

  project_module :maps do
    permission :view_maps, :maps => :index
  end
  menu :project_menu, :maps, { :controller => 'maps', :action => 'index' }, :caption => 'Maps', :after => :activity, :param => :project_id
end
