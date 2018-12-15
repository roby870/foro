Rails.application.routes.draw do
  resources :questions
  resources :sessions, :users, only: [:create]
  resources :questions do
    member do
      put 'resolve'
    end
    resources :answers
  end

end
