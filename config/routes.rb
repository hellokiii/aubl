Rails.application.routes.draw do
  root 'home#lineup'
  devise_for :users
  
  get 'home/dbupload'
  post 'home/upload'

  get 'home/choose'
  post 'home/check'
  get 'home/lineup'

  get 'home/average'

  get 'home/simulation'

  get 'post/index'
  get 'post/index/:message' => 'post#index'
  post 'post/create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
