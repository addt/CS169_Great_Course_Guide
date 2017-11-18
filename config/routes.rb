Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'login#index'

  # General
  get "/logout" => "application#logout"
  get "/cas/logout" => "login#index" #for testing purposes
  get "/welcome" => "application#welcome"
  get "/user" => "application#index"
  get "/edit" => "application#edit"
  post "/update" => "application#update"
  post "/create" => 'application#create'
  match '/users/email' => 'application#verify', :via => [:get]
  post '/updateFilters' => 'application#updateFilters'
  get '/about' => 'application#about'

  # Professors
  resources :professors, only: [:index, :show] do
    get :all, :on => :collection
    get :distinguished, :on => :collection
  end

  # Courses
  match '/courses/filter' => 'courses#filter', :via => [:get]

  resources :courses, only: [:index, :show] do
    get :all, :on => :collection
    get :schedule, :on => :collection
    get :compare, :on => :collection
  end

  # User Courses
  resources :user_courses, only: [:create, :destroy]
end
