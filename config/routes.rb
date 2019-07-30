Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :voted do
    member do
      patch :upvote
      patch :downvote
      patch :cancel_vote
    end
  end

  resources :questions, concerns: :voted do
    resources :answers, concerns: :voted, shallow: true do
      patch :select_best, on: :member
    end
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
end
