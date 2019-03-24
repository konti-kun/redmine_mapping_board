Redmine::Plugin.register :redmine_mapping_board do
  name 'Mapping board plugin'
  author 'konti-kun'
  description 'This is a plugin for Redmine'
  version '0.1.0'
  url 'https://github.com/konti-kun'
  author_url 'https://github.com/konti-kun'

  project_module :mappingboards do
    permission :view_mappingboards, :mappingboards => :index
    permission :create_and_delete_notes, :mappingboards => [:add_note,:del_note]
  end
  menu :project_menu, :mappingboards, { :controller => 'mappingboards', :action => 'index' }, :caption => :label_mapping_board, :after => :issues, :param => :project_id
end
