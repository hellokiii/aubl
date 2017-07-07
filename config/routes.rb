Rails.application.routes.draw do
  root 'home#dbupload'
  devise_for :users
  
  get 'home/dbupload'
  post 'home/upload'

  get 'home/choose'
  post 'home/check'
  get 'home/lineup'

  get 'home/average'

  get 'home/simulation'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
