Rails.application.routes.draw do
  devise_for :users, path: "", defaults: {format: :json},
    path_names: {
      sign_in: "login",
      sign_out: "logout",
      registration: "user",
      edit: "user"

    },
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
      passwords: "users/passwords"
    }
  devise_scope :user do
    # get "sign_in", to: "devise/sessions#new"
    # patch "update_password", to: "users/passwords#edit"
    # get "register", to: "devise/registrations#new"
    post "register", to: "devise/registrations#create"
    delete "sign_out", to: "devise/sessions#destroy"
    get "confirmation/sent", to: "confirmations#sent"
    get "confirmation/:confirmation_token", to: "confirmations#show"
    patch "confirmation", to: "confirmations#create"
  end

  scope :api, module: :api do
    resources :slots
    resources :items
  end
end
