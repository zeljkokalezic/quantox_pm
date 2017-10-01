Rails.application.routes.draw do

  api_version(:module => "V1", :path => {:value => "v1"}) do
    resources :projects
    resources :tasks
    resources :comments
    resources :documents
  end

  resources :comments
  resources :tasks
  resources :projects
  resources :documents

  root to: "projects#index"

  devise_for :users
  resources :posts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
