# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'mappingboards', :to => 'mappingboards#index'
get 'mappingboards/new', :to => 'mappingboards#new'
get 'mappingboards/apply_issue', :to => 'mappingboards#apply_issue'
post 'mappingboards/update_pos', :to => 'mappingboards#update_pos'
post 'mappingboards/add_note', :to => 'mappingboards#add_note'
post 'mappingboards/del_note', :to => 'mappingboards#del_note'
