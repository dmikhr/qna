Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  devise_scope :user do
    get '/sign_up_submit_email', to: 'oauth_callbacks#show_submit_email'
    post '/sign_up_submit_email', to: 'oauth_callbacks#submit_email'
  end

  root to: 'questions#index'

  concern :voted do
    member do
      patch :upvote
      patch :downvote
      patch :cancel_vote
    end
  end

  concern :commented do
    resources :comments, only: :create, shallow: true
  end

  resources :questions, concerns: [:voted, :commented] do
    resources :answers, concerns: [:voted, :commented], shallow: true do
      patch :select_best, on: :member
    end
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
