Rails.application.routes.draw do
	
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  resources :cmb, only: [:index]
  get '/cmb/set_profile'
  get '/cmb/get_bagels'
  get '/cmb/send_batch'
  get '/cmb/get_resources'
  get '/cmb/get_bagels_history'
  get '/cmb/get_photolabs'
end
