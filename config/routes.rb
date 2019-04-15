# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :mappingboards, :only => [:index,:show] do
  collection do
    get 'apply_issue'
  end
  resources :notes, :only => [:index, :new, :create, :destroy] do 
    member do
      post 'update_pos'
    end
  end
  resources :mappingimages, :only => [:index, :create] do
    collection do
      get 'get_images', defaults: { format: :json }
    end
  end
end
