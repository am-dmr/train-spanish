Rails.application.routes.draw do
  devise_for :users

  root to: 'dashboard#index'

  resources :trainings
  resources :words do
    member do
      get :fill_verb_forms
      put :create_verb_forms
    end
  end
end
