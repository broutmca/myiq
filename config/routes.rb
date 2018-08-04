Rails.application.routes.draw do

  get 'tests/all_my_score', to: 'tests#all_my_score'
  resources :tests do
    get :start
    get :result
    get :my_score
  end
  devise_for :users
  authenticate :user, lambda { |u| u.role == 'admin' } do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    root to: 'rails_admin/main#dashboard'
  end

  devise_scope :user do
    unauthenticated :user do
     root :to => 'devise/sessions#new'
    end
    authenticate :user, lambda { |u| u.role == 'user' } do
      root to: 'home#index'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
