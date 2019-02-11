# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'maps', :to => 'maps#index'
post 'maps/uploadfile', :to => 'maps#uploadfile'
post 'maps/update_pos', :to => 'maps#update_pos'
post 'maps/add_note', :to => 'maps#add_note'
post 'maps/del_note', :to => 'maps#del_note'
get 'maps/pdf', to: 'qrcodes#index'
