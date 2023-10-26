Rails.application.routes.draw do
  get 'members/dashboard'
  resources :categories
  # if user is admin then:
  authenticated :user, ->(user) { user.admin? } do
    get 'admin', to: "admin#index"
    get 'admin/posts'
    get 'admin/comments'
    get 'admin/users'
    # Assigning name to route
    get 'admin/show_post/:id', to: "admin#show_post", as: "admin_post"
  end

  # After purchase page - checkout
  get "checkout", to: "checkouts#show"
  get "checkout/success", to: "checkouts#success"
  get "billing", to: "billing#show"


  get 'search', to: "search#index"
  # get 'users/profile'
    devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
  get "/u/:id", to: "users#profile", as: "user"

  # Sends to after_signup controller
  resources :after_signup
  
  resources :posts do
    # /posts/1/comments/4
    resources :comments
  end
  
  get "about", to: "pages#about"  

  root "pages#home"
end
# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html