# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :mappingboards, :only => [:index, :show, :create, :update, :destroy] do
  collection do
    get 'apply_issue'
  end
  resources :notes, :only => [:index, :new, :create, :destroy] do 
    member do
      post 'update_pos'
      get 'lines'
    end
  end
  resources :mappingimages, :only => [:index, :create, :destroy, :update]
end

resources :mappingattachementimages, :only => [:index, :show]
get 'projects/:project_id/mappingissues', to: "mappingissues#index"
post 'projects/:project_id/mappingissues', to: "mappingissues#create"
