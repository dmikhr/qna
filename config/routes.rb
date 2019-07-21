Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true do
      patch :select_best, on: :member
    end
  end

  resources :files, only: :destroy
end
