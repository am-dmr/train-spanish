Rails.application.routes.draw do
  devise_for :users

  root to: 'dashboard#index'

  resources :trainings
  resources :words
end
