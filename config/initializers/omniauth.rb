Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :facebook, '349609268750448', 'fadbccabf5c9ba1be53cbd7017daf327',
  provider :facebook, '349609268750448', 'fadbccabf5c9ba1be53cbd7017daf327',
           :scope => 'email,user_birthday', :display => 'popup'
end