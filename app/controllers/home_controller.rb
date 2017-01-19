class HomeController < ApplicationController
	require 'httparty'

	# base_uri = 'https://api.coffeemeetsbagel.com/login'
	# options = {
	# 	body: {
	#     	'permissions': ["user_friends","contact_email","email","user_photos","public_profile","user_birthday","user_education_history"],
	#     	'app_version': '779',
	#     	'access_token': 'EAAE998BGKHABADnrlCZCYU3puhrfvc34vY2bvXFt88w9BOJataaZAYPB9CLjM4vZBkbW4pcRo3i7kAhLnyOi1rC6vMZBvHEFyhy5ui8MtLDfjv7hRBdr7ijA7EKvEynMM8qW00qCk53d5yf00ef4FCZBBuQK88EYFmglqpSoZAe6dFjsC4SU7j'
	#   	}
	# }
	# headers = {
	# 	'AppStore-Version': '3.4.1.779',
	# 	'App-Version': '779',
	# 	'Client': 'Android'
	# }

	def index
		# response = HTTParty.post(base_uri, headers: headers)
		
		Rails.logger.debug 'INSIDE HOME CONTROLLER'
	end

	def fblogin
		# base_uri = 'https://www.facebook.com/v2.7/dialog/oauth?client_id=273145509408031&e2e={"init":1478551666628}&sdk=android-4.14.0&scope=user_friends,email,user_photos,user_birthday,user_education_history&default_audience=friends&redirect_uri=fbconnect://success&auth_type=rerequest&display=touch&response_type=token,signed_request&return_scopes=true'
		base_uri = 'https://m.facebook.com/v2.7/dialog/oauth?client_id=273145509408031&e2e={"init":1478551666628}&sdk=android-4.14.0&scope=user_friends,email,user_photos,user_birthday,user_education_history&default_audience=friends&redirect_uri=fbconnect://success&auth_type=rerequest&display=touch&response_type=token,signed_request&return_scopes=true'
		# options = {
	 #    	'permissions': ['user_friends','contact_email','email','user_photos','public_profile','user_birthday','user_education_history'],
	 #    	'app_version': '779',
	 #    	'access_token': fbToken
		# }
		
		headers = { 
	        'User-Agent': 'Mozilla/5.0 (Linux; Android 4.4.4; Samsung Galaxy S4 - 4.4.4 - API 19 - 1080x1920 Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/33.0.0.0 Mobile Safari/537.36',
			'X-Requested-With': 'com.coffeemeetsbagel'
	    }
		response = HTTParty.get(base_uri.to_str,
			:headers => headers
		)
		# response = HTTParty.get(base_uri.to_str)

	    if response.success?
	      
	      @cmbInfo = [{"loginResult": "success", "sessionid":sessionid,"jsonObj": response}]
	    else
	      @cmbInfo = [{"loginResult": "failed", "sessionid": "NONE", "jsonObj":response}]
	    end
	end
	
end