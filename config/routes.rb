Rails.application.routes.draw do
  root "tasks#index"

  resources :tasks do
    member do
      patch :toggle
      get :confirm_delete
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
