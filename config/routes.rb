# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :users, only: [:index]
    resources :time_sheets, only: %i[create index], path: 'timesheets'
  end
  mount_devise_token_auth_for 'User', at: 'auth'
  scope path: 'admin' do
    resources :vouchers, only: %i[index create] do
      resources :transactions, only: [:create]
      post 'vouchers/purchases', controller: :purchases, action: :create
    end
    resources :orders, only: [:index]
  end
  scope path: 'api' do
    resources :vouchers, only: [:show]
    post 'vouchers/purchases', controller: :purchases, action: :create
    resources :orders, only: [:create]
    resources :services, only: [:index]
    resources :products, only: [:index]
  end
end
