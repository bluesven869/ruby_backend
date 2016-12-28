require 'httparty'
require 'json'
class CmbController < ApplicationController
	include HTTParty
	debug_output $stdout
	

	def index
		# Login to CoffeeMeetBagel
		base_uri = 'https://api.coffeemeetsbagel.com/login'
		fbToken = params[:fbToken].to_str
		options = {
	    	'permissions': ['user_friends','contact_email','email','user_photos','public_profile','user_birthday','user_education_history'],
	    	'app_version': '779',
	    	'access_token': fbToken
		}
		
		headers = { 
	        'AppStore-Version': '3.4.1.779',
			'App-Version': '779',
			'Client': 'Android',
			'Content-Type': 'application/json'
	    }

		response = self.class.post(base_uri.to_str, 
			:body=> options.to_json,
			:headers => headers
		)
	    if response.success?
	      loginResult = 1
	      resHeader = response.headers['set-cookie']
	      splittedStr = resHeader.split(/[;]/)

	      splittedStr = splittedStr[3].split(/[=]/)
	      sessionid = splittedStr[2]      
	      #@cmbInfo = [{"loginResult": "success get me", "sessionid": resHeader}]	      

          base_uri = "https://api.coffeemeetsbagel.com/profile/me"
          my_cookie = "sessionid="+sessionid
	      headers = {
	    	'AppStore-Version': '3.4.1.779',
			'App-Version': '779',
			'Client': 'Android',
			'Content-Type': 'application/json',
			'Facebook-Auth-Token': fbToken,
			'Cookie': my_cookie	
	      }
	      response = self.class.get(base_uri.to_str,
	      	:body=> options.to_json,
	      	:headers => headers)
		  if response.success?

		  	@cmbInfo = [{"loginResult": "success get me", "sessionid":sessionid,"jsonObj": response}]
		  else
			loginResult = "fail getting profile"
			@cmbInfo = [{"loginResult": loginResult, "sessionid": sessionid, "jsonObj": response}]
		  end		  
	    else
	      loginResult = "fail"
	      @cmbInfo = [{"loginResult": loginResult, "sessionid": "NONE", "jsonObj":response}]
	    end
	end

	def set_rofile
		#Set Profile
		fbToken = params[:fbToken].to_str
		sessionid = params[:sessionid].to_str
		@user 	= JSON.parse params[:user];
		base_uri = 'https://api.coffeemeetsbagel.com/profile/me'		
		my_cookie = "sessionid="+sessionid
      	headers = {
	    	'AppStore-Version': '3.4.1.779',
			'App-Version': '779',
			'Client': 'Android',
			'Content-Type': 'application/json',
			'Facebook-Auth-Token': fbToken,
			'Cookie': my_cookie	
      	}
      	options = {	    	
	    	'id': @user["id"],
	    	'name': @user["name"],
	    	'gender': @user["gender"],
	    	'birthday': @user["birthday"],
	    	'user__email': @user["email"],
	    	'criteria__gender': @user["criteria_gender"],
		}	
	    response = self.class.put(base_uri.to_str,
	    	:body=> options.to_json,
	      	:headers => headers)
	    if response.success?
	      	base_uri = "https://api.coffeemeetsbagel.com/profile/me"
          	my_cookie = "sessionid="+sessionid
	      	headers = {
	    	  'AppStore-Version': '3.4.1.779',
			  'App-Version': '779',
			  'Client': 'Android',
			  'Content-Type': 'application/json',
			  'Facebook-Auth-Token': fbToken,
			  'Cookie': my_cookie	
	      	}
	      	response = self.class.get(base_uri.to_str,
	      	  :body=> options.to_json,
	      	  :headers => headers)
		  	if response.success?
		  	  @cmbInfo = [{"loginResult": "success get me", "sessionid":sessionid,"jsonObj": response}]
		  	else
			  loginResult = "fail getting profile"
			@cmbInfo = [{"loginResult": loginResult, "sessionid": sessionid, "jsonObj": response}]
		  end	
	    else
		  	loginResult = "fail setting profile"
		  	@cmbInfo = [{"loginResult": loginResult, "sessionid": sessionid, "jsonObj": response}]
		end	  
	end

	def get_bagels
		#Get Bagels
		fbToken = params[:fbToken].to_str
		sessionid = params[:sessionid].to_str
		base_uri = 'https://api.coffeemeetsbagel.com/bagels'		
		my_cookie = "sessionid="+sessionid
      	headers = {
	    	'AppStore-Version': '3.4.1.779',
			'App-Version': '779',
			'Client': 'Android',
			'Content-Type': 'application/json',
			'Facebook-Auth-Token': fbToken,
			'Cookie': my_cookie	
      	}
      	options = {	    	
	    	'embed': 'profile',
	    	'prefetch': true
		}	
	    response = self.class.get(base_uri.to_str,
	    	:body=> options.to_json,
	      	:headers => headers)
	    if response.success?
	      	@BaglesInfo = [{"success": true, "jsonObj": response}]
	    else
		  	loginResult = "fail get bagels"
		  	@BaglesInfo = [{"success": false, "jsonObj": response}]
		end	  
	end

	def send_batch
		#send_batch
		fbToken = params[:fbToken].to_str
		sessionid = params[:sessionid].to_str
		hex_id = params[:hex_id].to_str
		base_uri = 'https://api.coffeemeetsbagel.com/batch'		
		my_cookie = "sessionid="+sessionid
      	headers = {
	    	'AppStore-Version': '3.4.1.779',
			'App-Version': '779',
			'Client': 'Android',
			'Content-Type': 'application/json',
			'Facebook-Auth-Token': fbToken,
			'Cookie': my_cookie	
      	}
    
      	options = [	    	
	    	{
	    		'relative_url': 'givetakes?embed=profile&updated_after='+hex_id,
	    		'method': 'GET'
	    	},
	    	{
	    		'relative_url': 'price',
	    		'method': 'GET'
	    	},
	    	{
	    		'relative_url': 'reportmeta?embed=profile&updated_after='+hex_id,
	    		'method': 'GET'
	    	},
	    	{
	    		'relative_url': 'risinggivetakes?embed=profile&updated_after='+hex_id,
	    		'method': 'GET'
	    	},
	    	{
	    		'relative_url': 'feature',
	    		'method': 'GET'
	    	},
	    	{
	    		'relative_url': 'reward',
	    		'method': 'GET'
	    	},
	    	{
	    		'relative_url': 'profile\/me',
	    		'method': 'GET'
	    	}
		]	
		
	    response = self.class.post(base_uri.to_str,
	    	:body=> options.to_json,
	      	:headers => headers)
	    if response.success?
	      	@BaglesInfo = [{"success": true, "jsonObj": response}]
	    else		  	
		  	@BaglesInfo = [{"success": false, "jsonObj": response}]
		end	  
	end
end
