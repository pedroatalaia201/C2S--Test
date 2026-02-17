Rails.application.routes.draw do
  resources :auth do
    collection do
      post :sign_in
      post :sign_up
      post :verify
    end
  end
end
