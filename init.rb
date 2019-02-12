Redmine::Plugin.register :redmine_mapping_board do
  name 'Mapping board plugin'
  author 'konti-kun'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/konti-kun'
  author_url 'https://github.com/konti-kun'

  require_dependency 'mapping_hooks'

  project_module :maps do
    permission :view_maps, :maps => :index
  end
  menu :project_menu, :maps, { :controller => 'maps', :action => 'index' }, :caption => 'Mapping board', :after => :issues, :param => :project_id
end
