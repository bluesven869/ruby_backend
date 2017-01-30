require 'httparty'
require 'json'
class HappnController < ApplicationController
	include HTTParty
	debug_output $stdout
	

	def index
		# Login to Happn		
		# IN    fbToken : FaceBook Token
		# Return sessionid
		
		if (not params.has_key?(:fbToken))
			@happnInfo = [{"Result": "Token Error","jsonObj": "Token"}]
		else
			base_uri = 'https://api.happn.fr/connect/oauth/token'			
			fbToken = params[:fbToken].to_str
			client_id = params[:client_id].to_str
			client_sercret = params[:client_sercret].to_str
			options = {		    	
		    	'client_id': client_id,
		    	'client_secret': client_sercret,
		    	'grant_type': 'assertion',
		    	'assertion_type': 'facebook_access_token',
		    	'assertion': fbToken,
		    	'scope': 'mobile_app'
			}
			
			headers = { 
		        'User-Agent': 'happn/19.12.0 android/16',
				'Accept-Language': 'en-US;q=1,en;q=0.75',
				'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
				'Host': 'api.happn.fr'
		    }
			response = self.class.post(base_uri.to_str, 
				:body=> options,
				:headers => headers
			)
		    if response.success?		      
		      @happnInfo = [{"Result": "success","jsonObj": response}]
		    else
		      @happnInfo = [{"Result": "failed", "jsonObj": response}]
		    end
		end
	end

	def register_device
		# Register Device
		#  IN     token  		: Happn Access Token
		#         user_id		: user_id from Happn
		#         android_id	: Android ID
		#  Return
		#         jsonObj  : Device Object

		if (not params.has_key?(:token)) || (not params.has_key?(:user_id))
			@happnInfo = [{"Result": "Token / User ID Error","jsonObj": "Token/UserID"}]
		else
			access_token 	= params[:token].to_str
			user_id 		= params[:user_id].to_str
			android_id 		= params[:android_id].to_str
			oauth_str 		= 'OAuth="'+access_token+'"'
			uuid			= SecureRandom.uuid
			headers = { 
		        'User-Agent': 'happn/19.12.0 android/16',
				'Accept-Language': 'en-US;q=1,en;q=0.75',
				'Authorization': oauth_str,
				'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
				'Host': 'api.happn.fr'
		    }

	      	options = {	    	
		    	'android_id': android_id,
		    	'app_build': '19.12.0',
		    	'country_id': 'US',
		    	'idfa': uuid,
		    	'language_id': 'en',
		    	'type': 'android',
		    	'token': '',
		    	'os_build': 16
			}	

			base_uri 		= 'https://api.happn.fr/api/users/'+user_id+'/devices/'
			
		    response = self.class.post(base_uri.to_str,
		    	:body=> options,
		      	:headers => headers)
		    if response.success?
		      	@happnInfo = [{"Result": "success","jsonObj": response}]
			else
			  	@happnInfo = [{"Result": "failed","jsonObj": response}]
			end	  
		end
	end

	def set_profile_first
		#Set Profile on First
		# Register Device
		#  IN     token  	: Happn Access Token
		#         user_id	: user_id from Happn
		#  Return
		#         jsonObj  : user Profile Info

		if (not params.has_key?(:token)) || (not params.has_key?(:user_id))
			@happnInfo = [{"Result": "Token / User ID Error","jsonObj": "Token/UserID"}]
		else
			access_token 	= params[:token].to_str
			user_id 		= params[:user_id].to_str
			oauth_str 		= 'OAuth="'+access_token+'"'
			headers = { 
		        'User-Agent': 'happn/19.12.0 android/16',
				'Accept-Language': 'en-US;q=1,en;q=0.75',
				'Authorization': oauth_str,
				'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
				'Host': 'api.happn.fr'
		    }

	      	options = {	    	
		    	'update_activity': 'true'
			}	

			base_uri 		= 'https://api.happn.fr/api/users/'+user_id+'?fields=id,first_name,age,birth_date,gender,register_date,credits,job,workplace,school,about,nb_photos,achievements,stats.fields(nb_invites,nb_charms,nb_crushes),profiles.fields(mode,url,width,height),matching_preferences,notification_settings,unread_conversations,unread_notifications.types(471,524,525,526,529,530,531,565,791,792),last_tos_version_accepted'
			
			
		    response = self.class.put(base_uri.to_str,
		    	:body=> options,
		      	:headers => headers)
		    if response.success?
		      	@happnInfo = [{"Result": "success","jsonObj": response}]
			else
			  	@happnInfo = [{"Result": "failed","jsonObj": response}]
			end	  
		end
	end

	def refresh_token
		# Refresh Token
		#
		#  IN     token  	: Happn Access Token
		#         user_id	: user_id from Happn
		#  Return
		#         jsonObj  : user Profile Info

		if (not params.has_key?(:refresh_token)) || (not params.has_key?(:user_id))
			@happnInfo = [{"Result": "Token / User ID Error","jsonObj": "Token/UserID"}]
		else
			refresh_token 	= params[:refresh_token].to_str
			user_id 		= params[:user_id].to_str
			dev_id			= params[:dev_id].to_str
			client_id		= params[:client_id].to_str
			client_secret	= params[:client_secret].to_str
			headers = { 
		        'User-Agent': 'happn/19.12.0 android/16',
				'Accept-Language': 'en-US;q=1,en;q=0.75',
				'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
				'Host': 'api.happn.fr',
				'X-Happn-DID': dev_id
		    }

	      	options = {	    	
		    	'client_id': client_id,
		    	'client_secret': client_secret,
		    	'grant_type': 'refresh_token',
		    	'refresh_token': refresh_token,
		    	'scope': 'mobile_app'
			}	

			base_uri 		= 'https://api.happn.fr/connect/oauth/token'
			
			
		    response = self.class.post(base_uri.to_str,
		    	:body=> options,
		      	:headers => headers)
		    if response.success?
		      	@happnInfo = [{"Result": "success","jsonObj": response}]
			else
			  	@happnInfo = [{"Result": "failed","jsonObj": response}]
			end	  
		end
	end

	def get_profile
		#Get Profile
		#  IN     fbToken  : FaceBook Token
		#         sessionid: CMB session id
		#  Return
		#         jsonObj  : User Profile Info
		if (not params.has_key?(:fbToken)) || (not params.has_key?(:sessionid))
			@profileInfo = [{"loginResult": "Token Error", "sessionid":"NoSession","jsonObj": "Token"}]
		else
			fbToken = params[:fbToken].to_str
			sessionid = params[:sessionid].to_str
			base_uri = "https://api.coffeemeetsbagel.com/profile/me"
          	my_cookie = "sessionid="+sessionid
          	options = {

          	}
	      	headers = {
	    	  'AppStore-Version': '3.4.1.779',
			  'App-Version': '779',
			  'Client': 'Android',
			  'Device-Name': 'Genymotion Samsung Galaxy S4 - 4.4.4 - API 19 - 1080x1920',
			  'Content-Type': 'application/json',
			  'Facebook-Auth-Token': fbToken,
			  'Cookie': my_cookie	
	      	}
	      	response = self.class.get(base_uri.to_str,
	      	  :body=> options.to_json,
	      	  :headers => headers)
		  	if response.success?
		  	  @profileInfo = [{"loginResult": "success", "sessionid":sessionid,"jsonObj": response}]
		  	else
			  @profileInfo = [{"loginResult": "failed", "sessionid": sessionid, "jsonObj": response}]
			end	 
		end
	end 

	def set_profile
		#Set Profile
		#  IN     fbToken  : FaceBook Token
		#         sessionid: CMB session id
		#         user     : User Profile Info
		#  Return
		#         jsonObj  : User Profile Info (changed)

		if (not params.has_key?(:fbToken)) || (not params.has_key?(:sessionid))
			@cmbInfo = [{"loginResult": "Token Error", "sessionid":"NoSession","jsonObj": "Token"}]
		else
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
	      	# options = {}
	      	# options['id'] = @user["id"];
	      	# options['name'] = @user["name"];
	      	# options['gender'] = @user["gender"];
	      	# options['birthday'] = @user["birthday"];
	      	# options['user__email'] = @user["email"];
	      	# options['criteria__gender'] = @user["criteria_gender"];
	      	options = {	    	
		    	'id': @user["id"],
		    	'language_code': @user["language_code"],
		    	'name': @user["name"],
		    	'gender': @user["gender"],
		    	'birthday': @user["birthday"],
		    	'user__email': @user["email"],
		    	'criteria__gender': @user["criteria_gender"],
		    	'location': @user["location"]
			}	
		    response = self.class.put(base_uri.to_str,
		    	:body=> options.to_json,
		      	:headers => headers)
		    if response.success?
		      	@profileInfo = [{"loginResult": "Set Profile Success", "sessionid": sessionid, "jsonObj": response}]			  	
			else
			  	@profileInfo = [{"loginResult": "Set Profile Failed", "sessionid": sessionid, "jsonObj": response}]
			end	  
		end
	end

	def get_bagels
		# Get Bagels
		#    IN      fbToken : FaceBook Token
		#            sessionid: CMB Session ID
		#    OUT     
		#	         jsonObj : Today's Bagel Info 

		if (not params.has_key?(:fbToken)) || (not params.has_key?(:sessionid))
			@BaglesInfo = [{"success": false, "jsonObj": "No Authenticated"}]
		else
			fbToken = params[:fbToken].to_str
			sessionid = params[:sessionid].to_str
			base_uri = 'https://api.coffeemeetsbagel.com/bagels?embed=profile&prefetch=true'		
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
		    	# :body=> options.to_json,
		      	:headers => headers)

		    if response.success?
		      	@BaglesInfo = [{"success": true, "jsonObj": response}]
		    else
			  	loginResult = "fail get bagels"
			  	@BaglesInfo = [{"success": false, "jsonObj": response}]
			end
		end
	end
	def get_bagels_history
		# Get Bagels History
		#    IN      fbToken : FaceBook Token
		#            sessionid: CMB Session ID
		#            @bagel : BagelObject(hex_id, cursor_after)
		#    OUT     
		#	         jsonObj : Bagels History before cursor_after 

		if (not params.has_key?(:fbToken)) || (not params.has_key?(:sessionid)) || (not params.has_key?(:bagel))
			@BaglesInfo = [{"success": false, "jsonObj": "Params Error"}]
		else
			fbToken = params[:fbToken].to_str
			sessionid = params[:sessionid].to_str		
			@bagel 	= JSON.parse params[:bagel];
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
		    	'prefetch': true,
		    	'cursor_after': @bagel["cursor_after"],
		    	'updated_after': @bagel["hex_id"],
			}	
		    response = self.class.get(base_uri.to_str,
		    	:body=> options.to_json,
		      	:headers => headers)
		    if response.success?
		      	@BaglesList = [{"success": true, "jsonObj": response}]
		    else		  	
			  	@BaglesList = [{"success": false, "jsonObj": response}]
			end	  
		end
	end
	def send_batch
		# Batch Command
		if (not params.has_key?(:fbToken)) || (not params.has_key?(:sessionid))# || (not params.has_key?(:hex_id))
			@BaglesInfo = [{"success": false, "jsonObj": "Params Error"}]
		else
			fbToken = params[:fbToken].to_str
			sessionid = params[:sessionid].to_str
			if params.has_key?(:hex_id)
				hex_id = params[:hex_id].to_str
			end
			
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

	      	addedString = ''
	      	if hex_id
	      		addedString = '&updated_after='+hex_id	
	      	end
	    
	      	options = [	    	
		    	{
		    		'relative_url': 'givetakes?embed=profile'+addedString,
		    		'method': 'GET'
		    	},
		    	{
		    		'relative_url': 'price',
		    		'method': 'GET'
		    	},
		    	{
		    		'relative_url': 'reportmeta?embed=profile'+addedString,
		    		'method': 'GET'
		    	},
		    	{
		    		'relative_url': 'risinggivetakes?embed=profile'+addedString,
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
	def get_resources
		# Get Resource
		#    IN      fbToken : FaceBook Token
		#            sessionid: CMB Session ID
		#    OUT     
		#	         jsonObj : Resource of App.
		if (not params.has_key?(:fbToken)) || (not params.has_key?(:sessionid))
			@ResourceInfo = [{"success": false, "jsonObj": "No Authenticated"}]
		else
			fbToken = params[:fbToken].to_str
			sessionid = params[:sessionid].to_str
			base_uri = 'https://api.coffeemeetsbagel.com/resource/locale/en_us.json'		
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
		    	
			}	
		    response = self.class.get(base_uri.to_str,
		    	:body=> options.to_json,
		      	:headers => headers)
		    if response.success?
		      	@ResourceInfo = [{"success": true, "jsonObj": response}]
		    else
			  	@ResourceInfo = [{"success": false, "jsonObj": response}]
			end	  
		end
	end
	def get_photolabs
		#Get Bagels
		#    IN      fbToken : FaceBook Token
		#            sessionid: CMB Session ID
		#    OUT     
		#	         jsonObj : Photo Labs

		if (not params.has_key?(:fbToken)) || (not params.has_key?(:sessionid))
			@PhotoLabs = [{"success": false, "jsonObj": "No Authenticated"}]
		else
			fbToken = params[:fbToken].to_str
			sessionid = params[:sessionid].to_str
			base_uri = 'https://api.coffeemeetsbagel.com/photolabs'		
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
		    	
			}	
		    response = self.class.get(base_uri.to_str,
		    	:body=> options.to_json,
		      	:headers => headers)
		    if response.success?
		      	@PhotoLabs = [{"success": true, "jsonObj": response}]
		    else
			  	@PhotoLabs = [{"success": false, "jsonObj": response}]
			end
		end
	end

	def give_take
		# Give Take
		#    IN      fbToken : FaceBook Token
		#            sessionid: CMB Session ID
		#  			 customer_id : Bagel_id
		#    OUT     
		#	         success : take result

		if (not params.has_key?(:fbToken)) || (not params.has_key?(:sessionid)) || (not params.has_key?(:customer_id) )
			@GiveTakeResult = [{"success": false, "jsonObj": "Params Error"}]
		else
			fbToken 		= params[:fbToken].to_str
			sessionid 		= params[:sessionid].to_str
			customer_id 	= params[:customer_id].to_str
			base_uri 		= 'https://api.coffeemeetsbagel.com/givetake'		
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
		    	"id":customer_id,
		    	"shown":true
			}	
		    response = self.class.put(base_uri.to_str,
		    	:body=> options.to_json,
		      	:headers => headers)	    
		    if response.success?
		      	@GiveTakeResult = [{"success": true}]
		    else
			  	@GiveTakeResult = [{"success": false}]
			end	     
		end 
	end

	def purchase
		# Purchase
		#    IN      fbToken : FaceBook Token
		#            sessionid: CMB Session ID
		#  			 @purchase : Purchase Info(item_count, item_name, expected_price, give_ten_id)
		#    OUT     
		#	         success : take result

		if (not params.has_key?(:fbToken)) || (not params.has_key?(:sessionid)) || (not params.has_key?(:purchase))
			@PurchaseResult = [{"success": false, "jsonObj": "Params Error"}]
		else
			fbToken 		= params[:fbToken].to_str
			sessionid 		= params[:sessionid].to_str
			@purchase 	= JSON.parse params[:purchase];
			base_uri 		= 'https://api.coffeemeetsbagel.com/purchase'		
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
		    	"item_count":@purchase["item_count"],
		    	"item_name":@purchase["item_name"],
		    	"expected_price":@purchase["expected_price"],
		    	"give_ten_id":@purchase["give_ten_id"]
			}	
		    response = self.class.post(base_uri.to_str,
		    	:body=> options.to_json,
		      	:headers => headers)	    
		    if response.success?
		      	@PurchaseResult = [{"success": true}]
		    else
			  	@PurchaseResult = [{"success": false}]
			end
		end    
	end

	def report
		#Report
		#    IN      fbToken : FaceBook Token
		#            sessionid: CMB Session ID
		#    OUT     
		#	         jsonObj : Report Result
		if (not params.has_key?(:fbToken)) || (not params.has_key?(:sessionid))
			@ReportResult = [{"success": false, "jsonObj": "No Authenticated"}]
		else
			fbToken 		= params[:fbToken].to_str
			sessionid 		= params[:sessionid].to_str
			base_uri 		= 'https://api.coffeemeetsbagel.com/report/4'		
			my_cookie = "sessionid="+sessionid
	      	headers = {
		    	'AppStore-Version': '3.4.1.779',
				'App-Version': '779',
				'Client': 'Android',
				'Content-Type': 'application/json',
				'Facebook-Auth-Token': fbToken,
				'Cookie': my_cookie	
	      	}
	      	options = {}	
		    response = self.class.get(base_uri.to_str,
		    	:body=> options.to_json,
		      	:headers => headers)	    
		    if response.success?
		      	@ReportResult = [{"success": true, jsonObj:response}]
		    else
			  	@ReportResult = [{"success": false, jsonObj:response}]
			end	   
		end   
	end
end
