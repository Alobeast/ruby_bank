Rails.application.routes.draw do
  devise_for :users
  root 'accounts#show'
  resource :account do
    get "new_transfer", on: :member
    post "new_transfer", on: :member
  end
end
