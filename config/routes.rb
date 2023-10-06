Rails.application.routes.draw do
  resources :posts
  get "about", to: "pages#about"  

  root "pages#home"
end
# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html