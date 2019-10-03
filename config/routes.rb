require 'sidekiq/web'

Rails.application.routes.draw do

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  namespace :user do
    get '/sign_up_submit_email', to: 'emails#new'
    post '/sign_up_submit_email', to: 'emails#create'
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

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, except: [:new, :edit] do
        resources :answers, shallow: true, only: [:index, :create, :show]
      end
    end
  end

  resources :subscriptions, only: [:create, :destroy]

  resources :searches, only: :index

  mount ActionCable.server => '/cable'

end
