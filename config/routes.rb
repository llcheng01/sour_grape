Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users
  resources :users, only: [:index, :show]
  resources :products, only: [:index, :show]

  mount GrapeExampleApp::V1 => '/'

end
