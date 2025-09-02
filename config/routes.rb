RedmineApp::Application.routes.draw do
  resources :support_widgets do
    member do
      get :generate_script
    end
  end
  get '/support_widget.js' => 'support_widgets#serve_js'
  post "create_ticket/:token", to: "support_widgets#create_ticket", as: :create_ticket_by_token
end