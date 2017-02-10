Rails.application.routes.draw do
	
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  resources :cmb, only: [:index]
  get '/cmb/set_profileprocess1'
  get '/cmb/set_profileprocess2'
  get '/cmb/set_profileprocess3'
  get '/cmb/get_profile'
  get '/cmb/set_profile'
  get '/cmb/get_bagels'
  get '/cmb/send_batch'
  get '/cmb/get_resources'
  get '/cmb/get_bagels_history'
  get '/cmb/get_photolabs'
  get '/cmb/give_take'
  get '/cmb/purchase'
  get '/cmb/report'
  get '/cmb/photo'
  get '/cmb/chat_message'
  get '/cmb/get_chat_list'
  get '/home/fblogin'

  resources :home, only: [:index]

  get '/auth/:provider/callback' => 'home#fblogin'

  # get '/signout' => 'sessions#destroy', :as => :signout

  # get '/signin' => 'sessions#new', :as => :signin

  resources :tinder, only: [:index]
  
  resources :happn, only: [:index]
  get '/happn/register_device'
  get '/happn/set_profile_first'
  get '/happn/refresh_token'
  get '/happn/discover_new_prospects'
  get '/happn/get_list_of_chats'
  get '/happn/get_conversation_msg'  
  get '/happn/send_conversation_msg'  
  get '/happn/get_user_profile'
  get '/happn/like_somebody'
  get '/happn/charm_somebody'
  get '/happn/reject_somebody' 
  get '/happn/update_profile'  
  get '/happn/get_user_setting'  
  get '/happn/set_user_setting'  
end
