Redmine::Plugin.register :redmine_mapping_board do
  name 'Mapping board plugin'
  author 'konti-kun'
  description 'This is a plugin for Redmine'
  version '0.4.2'
  url 'https://github.com/konti-kun'
  author_url 'https://github.com/konti-kun'

  require_dependency 'issue'
  unless Issue.included_modules.include? IssuePatch
    Issue.send(:include, IssuePatch)
  end

  project_module :mappingboards do
    permission :view_mappingboards, :mappingboards => :index
  end
  menu :project_menu, :mappingboards, { :controller => 'mappingboards', :action => 'index' }, :caption => :label_mapping_board, :after => :issues, :param => :project_id
end
