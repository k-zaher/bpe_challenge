Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :ng do
    namespace :v1 do
      resources :sessions, only: [:create]
      resources :states do
        collection do
          put :update_order
        end
      end
      resources :vehicles, only: [:index, :show, :update] do
        member do
          put :next_state
        end
      end
    end
  end
end
