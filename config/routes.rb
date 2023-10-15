Rails.application.routes.draw do
  # if user is admin then:
  authenticated :user, ->(user) { user.admin? } do
    get 'admin', to: "admin#index"
    get 'admin/posts'
    get 'admin/comments'
    get 'admin/users'
    get 'admin/show_post'
  end

  get 'search', to: "search#index"
  get 'users/profile'
    devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  get "/u/:id", to: "users#profile", as: "user"
  
  resources :posts do
    # /posts/1/comments/4
    resources :comments
  end
  
  get "about", to: "pages#about"  

  root "pages#home"
end
# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html