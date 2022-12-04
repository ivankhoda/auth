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
      registrations: "users/registrations"
    }
  devise_scope :user do
    # get "sign_in", to: "devise/sessions#new"
    patch "update_password", to: "users/passwords#update"
    get "register", to: "devise/registrations#new"
    post "register", to: "devise/registrations#create"
    delete "sign_out", to: "devise/sessions#destroy"
    get "confirmation/sent", to: "confirmations#sent"
    get "confirmation/:confirmation_token", to: "confirmations#show"
    patch "confirmation", to: "confirmations#create"
  end
  namespace :api do
    devise_for :users, defaults: {format: :json},
      class_name: "ApiUser",
      skip: [:registrations, :invitations, :passwords, :confirmations, :unlocks],
      path: "",
      path_names: {sign_in: "login",
                   sign_out: "logout"}
    devise_scope :api_user do
      get "login", to: "devise/sessions#new"
      delete "logout", to: "devise/sessions#destroy"
    end
  end
end
