Rails.application.routes.draw do
  resources :auth do
    collection do
      post :sign_in
      post :sign_up
      get  :verify
    end
  end
end
