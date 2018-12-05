Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # APO Routes
  resources :apos, :tags, :collections, :workflows, :defaults => { :format => 'json' }

  root :controller => 'about', :action => 'index'
  get 'about/version' => 'about#version'
  mount AboutPage::Engine => '/about(.:format)' # Or whever you want to access the about page
end
