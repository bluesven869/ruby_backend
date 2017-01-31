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
				'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
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
				'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
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
				'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
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

		if (not params.has_key?(:refresh_token)) || (not params.has_key?(:dev_id))
			@happnInfo = [{"Result": "Token / DeviceID Error","jsonObj": "Token/DeviceID"}]
		else
			refresh_token 	= params[:refresh_token].to_str			
			dev_id			= params[:dev_id].to_str
			client_id		= params[:client_id].to_str
			client_secret	= params[:client_secret].to_str
			headers = { 
		        'User-Agent': 'happn/19.12.0 android/16',
				'Accept-Language': 'en-US;q=1,en;q=0.75',
				'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
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

	def discover_new_prospects
		# Discover New Prospects
		#
		#  IN     token  	: Happn Access Token
		#         user_id	: user_id from Happn
		#         dev_id	: RegisterdDevice ID 
		#  Return
		#         jsonObj  : New Prospects Array

		if (not params.has_key?(:token)) || (not params.has_key?(:user_id))|| (not params.has_key?(:dev_id))
			@happnInfo = [{"Result": "Token / User ID / Device ID Error","jsonObj": "Token/UserID/DeviceID"}]
		else
			access_token	= params[:token].to_str
			user_id 		= params[:user_id].to_str
			dev_id			= params[:dev_id].to_str
			oauth_str 		= 'OAuth="'+access_token+'"'
			headers = { 
		        'User-Agent': 'happn/19.12.0 android/16',
				'Accept-Language': 'en-US;q=1,en;q=0.75',
				'Content-Type': 'application/json; charset=UTF-8',
				'Authorization': oauth_str,
				'Host': 'api.happn.fr',
				'X-Happn-DID': dev_id
		    }

	      	options = {	    			    	
			}	

			base_uri 		= 'https://api.happn.fr/api/users/'+user_id+'/crossings?offset=0&limit=16&fields=id,modification_date,notification_type,nb_times,notifier.fields(id,type,job,is_accepted,workplace,my_relation,distance,gender,is_charmed,nb_photos,first_name,age,already_charmed,has_charmed_me,availability,is_invited,last_invite_received,profiles.mode(1).width(720).height(1232).fields(width,height,mode,url))'
			
			
		    response = self.class.get(base_uri.to_str,
		    	:body=> options,
		      	:headers => headers)
		    if response.success?
		      	@happnInfo = [{"Result": "success","jsonObj": response}]
			else
			  	@happnInfo = [{"Result": "failed","jsonObj": response}]
			end	  
		end
	end
	def get_list_of_chats
		# Get List Of Chats
		#
		#  IN     token  	: Happn Access Token
		#         user_id	: user_id from Happn
		#         dev_id	: RegisterdDevice ID 
		#  Return
		#         jsonObj  : New Prospects Array

		if (not params.has_key?(:token)) || (not params.has_key?(:user_id))|| (not params.has_key?(:dev_id))
			@happnInfo = [{"Result": "Token / User ID / Device ID Error","jsonObj": "Token/UserID/DeviceID"}]
		else
			access_token	= params[:token].to_str
			user_id 		= params[:user_id].to_str
			dev_id			= params[:dev_id].to_str
			oauth_str 		= 'OAuth="'+access_token+'"'
			headers = { 
		        'User-Agent': 'happn/19.12.0 android/16',
				'Accept-Language': 'en-US;q=1,en;q=0.75',
				'Content-Type': 'application/json; charset=UTF-8',
				'Authorization': oauth_str,
				'Host': 'api.happn.fr',
				'X-Happn-DID': dev_id
		    }

	      	options = {	    			    	
			}	

			base_uri 		= 'https://api.happn.fr/api/users/'+user_id+'/conversations?offset=0&limit=16&fields=id,participants.fields(user.fields(id,first_name,age,is_moderator,profiles.mode(0).width(72).height(72).fields(width,height,mode,url))),is_read,creation_date,modification_date,last_message.fields(creation_date,message,sender)'
			
			
		    response = self.class.get(base_uri.to_str,
		    	:body=> options,
		      	:headers => headers)
		    if response.success?
		      	@happnInfo = [{"Result": "success","jsonObj": response}]
			else
			  	@happnInfo = [{"Result": "failed","jsonObj": response}]
			end	  
		end
	end 
	def get_conversation_msg
		# Get List Of Chats
		#
		#  IN     token  	: Happn Access Token
		#         dev_id	: RegisterdDevice ID 
		# 		  msg_id	: <partner_id>-<my_id> 
		#  Return
		#         jsonObj  : New Prospects Array

		if (not params.has_key?(:token)) || (not params.has_key?(:msg_id))|| (not params.has_key?(:dev_id))
			@happnInfo = [{"Result": "Token / Message ID / Device ID Error","jsonObj": "Token/MessageID/DeviceID"}]
		else
			access_token	= params[:token].to_str
			dev_id			= params[:dev_id].to_str
			msg_id			= params[:msg_id].to_str
			oauth_str 		= 'OAuth="'+access_token+'"'
			headers = { 
		        'User-Agent': 'happn/19.12.0 android/16',
				'Accept-Language': 'en-US;q=1,en;q=0.75',
				'Content-Type': 'application/json; charset=UTF-8',
				'Authorization': oauth_str,
				'Host': 'api.happn.fr',
				'X-Happn-DID': dev_id
		    }

	      	options = {	    			    	
			}	

			base_uri 		= 'https://api.happn.fr/api/conversations/'+msg_id+'/messages/?offset=0&limit=16&fields=id,message,creation_date,sender.fields(id,first_name,age,profiles.mode(0).width(36).height(36).fields(mode,width,height,url),clickable_profile_link,clickable_message_link)'
			
			
		    response = self.class.get(base_uri.to_str,
		    	:body=> options,
		      	:headers => headers)
		    if response.success?
		      	@happnInfo = [{"Result": "success","jsonObj": response}]
			else
			  	@happnInfo = [{"Result": "failed","jsonObj": response}]
			end	  
		end
	end 

	def send_conversation_msg
		# Send Messages
		#
		#  IN     token  	: Happn Access Token
		#         user_id	: user_id from Happn
		#         dev_id	: RegisterdDevice ID 
		# 		  msg_id	: <partner_id>-<my_id> 
		#         msg       : Real Send Message
		#  Return
		#         jsonObj  : New Prospects Array

		if (not params.has_key?(:token)) || (not params.has_key?(:msg_id))|| (not params.has_key?(:dev_id))
			@happnInfo = [{"Result": "Token / msg_id / Device ID Error","jsonObj": "Token/msg_id/DeviceID"}]
		else
			access_token	= params[:token].to_str
			dev_id			= params[:dev_id].to_str
			msg_id			= params[:msg_id].to_str
			msg				= params[:msg].to_str
			oauth_str 		= 'OAuth="'+access_token+'"'
			headers = { 
		        'User-Agent': 'happn/19.12.0 android/16',
				'Accept-Language': 'en-US;q=1,en;q=0.75',
				'Content-Type': 'application/json; charset=UTF-8',
				'Authorization': oauth_str,
				'Host': 'api.happn.fr',
				'X-Happn-DID': dev_id
		    }

	      	options = {
	      		"fields": "message,creation_date,sender.fields(id)",
    			"message": msg # text we’re going to send	    			    	
			}	

			base_uri 		= 'https://api.happn.fr/api/conversations/'+msg_id+'/messages/'
			
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

	def get_user_profile
		# Get User's Profile
		#
		#  IN     token  		: Happn Access Token
		#         dev_id		: RegisterdDevice ID 
		# 		  other_user_id	: user id to view		
		#  Return
		#         jsonObj  : New Prospects Array

		if (not params.has_key?(:token)) || (not params.has_key?(:other_user_id))|| (not params.has_key?(:dev_id))
			@happnInfo = [{"Result": "Token / User ID / Device ID Error","jsonObj": "Token/UserID/DeviceID"}]
		else
			access_token	= params[:token].to_str
			dev_id			= params[:dev_id].to_str
			other_user_id	= params[:other_user_id].to_str			
			oauth_str 		= 'OAuth="'+access_token+'"'
			headers = { 
		        'User-Agent': 'happn/19.12.0 android/16',
				'Accept-Language': 'en-US;q=1,en;q=0.75',
				'Content-Type': 'application/json; charset=UTF-8',
				'Authorization': oauth_str,
				'Host': 'api.happn.fr',
				'X-Happn-DID': dev_id
		    }

	      	options = {			    	
			}	

			base_uri 		= 'https://api.happn.fr/api/users/'+other_user_id+'?fields=type,about,is_accepted,first_name,age,job,workplace,school,modification_date,profiles.mode(1).width(720).height(1232).fields(url,width,height,mode),last_meet_position,my_relation,is_charmed,distance,gender,spotify_tracks,social_synchronization.fields(instagram),clickable_profile_link,clickable_message_link,availability,is_invited,last_invite_received'
			
		    response = self.class.get(base_uri.to_str,
		    	:body=> options,
		      	:headers => headers)
		    if response.success?
		      	@happnInfo = [{"Result": "success","jsonObj": response}]
			else
			  	@happnInfo = [{"Result": "failed","jsonObj": response}]
			end	  
		end
	end 

	def like_somebody
		# Like SomeBody
		#
		#  IN     token  		: Happn Access Token
		#         user_id		: user_id from Happn
		#         other_user_id	: PartnerID
		#         dev_id		: RegisterdDevice ID 
		#  Return
		#         jsonObj 		: Result

		if (not params.has_key?(:token)) || (not params.has_key?(:user_id))|| (not params.has_key?(:other_user_id))|| (not params.has_key?(:dev_id))
			@happnInfo = [{"Result": "failed","jsonObj": "Token/UserID/PartnerID/DeviceID ERROR"}]
		else
			access_token	= params[:token].to_str
			user_id 		= params[:user_id].to_str
			other_user_id	= params[:other_user_id].to_str
			dev_id			= params[:dev_id].to_str
			oauth_str 		= 'OAuth="'+access_token+'"'
			headers = { 
		        'User-Agent': 'happn/19.12.0 android/16',
				'Accept-Language': 'en-US;q=1,en;q=0.75',
				'Content-Type': 'application/json; charset=UTF-8;',
				'Authorization': oauth_str,
				'Host': 'api.happn.fr',
				'X-Happn-DID': dev_id
		    }

	      	options = {	    			    	
			}	

			base_uri 		= 'https://api.happn.fr/api/users/'+user_id+'/accepted/'+other_user_id
			
			
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
	
	def charm_somebody
		# Charm SomeBody
		#
		#  IN     token  		: Happn Access Token
		#         user_id		: user_id from Happn
		#         other_user_id	: PartnerID
		#         dev_id		: RegisterdDevice ID 
		#  Return
		#         jsonObj 		: Result

		if (not params.has_key?(:token)) || (not params.has_key?(:user_id))|| (not params.has_key?(:other_user_id))|| (not params.has_key?(:dev_id))
			@happnInfo = [{"Result": "failed","jsonObj": "Token/UserID/PartnerID/DeviceID ERROR"}]
		else
			access_token	= params[:token].to_str
			user_id 		= params[:user_id].to_str
			other_user_id	= params[:other_user_id].to_str
			dev_id			= params[:dev_id].to_str
			oauth_str 		= 'OAuth="'+access_token+'"'
			headers = { 
		        'User-Agent': 'happn/19.12.0 android/16',
				'Accept-Language': 'en-US;q=1,en;q=0.75',
				'Content-Type': 'application/json; charset=UTF-8;',
				'Authorization': oauth_str,
				'Host': 'api.happn.fr',
				'X-Happn-DID': dev_id
		    }

	      	options = {	    			    	
			}	

			base_uri 		= 'https://api.happn.fr/api/users/'+user_id+'/pokes/'+other_user_id
			
			
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

	def reject_somebody
		# Reject SomeBody
		#
		#  IN     token  		: Happn Access Token
		#         user_id		: user_id from Happn
		#         other_user_id	: PartnerID
		#         dev_id		: RegisterdDevice ID 
		#  Return
		#         jsonObj 		: Result

		if (not params.has_key?(:token)) || (not params.has_key?(:user_id))|| (not params.has_key?(:other_user_id))|| (not params.has_key?(:dev_id))
			@happnInfo = [{"Result": "failed","jsonObj": "Token/UserID/PartnerID/DeviceID ERROR"}]
		else
			access_token	= params[:token].to_str
			user_id 		= params[:user_id].to_str
			other_user_id	= params[:other_user_id].to_str
			dev_id			= params[:dev_id].to_str
			oauth_str 		= 'OAuth="'+access_token+'"'
			headers = { 
		        'User-Agent': 'happn/19.12.0 android/16',
				'Accept-Language': 'en-US;q=1,en;q=0.75',
				'Content-Type': 'application/json; charset=UTF-8;',
				'Authorization': oauth_str,
				'Host': 'api.happn.fr',
				'X-Happn-DID': dev_id
		    }

	      	options = {	    			    	
			}	

			base_uri 		= 'https://api.happn.fr/api/users/'+user_id+'/rejected/'+other_user_id
			
			
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
	def update_profile
		# Update user profile
		#
		#  IN     token  		: Happn Access Token
		#         user_id		: user_id from Happn
		#         user_info		: PartnerID
		#         dev_id		: RegisterdDevice ID 
		#  Return
		#         jsonObj 		: Result

		if (not params.has_key?(:token)) || (not params.has_key?(:user_id))|| (not params.has_key?(:dev_id))
			@happnInfo = [{"Result": "failed","jsonObj": "Token/UserID/DeviceID ERROR"}]
		else
			access_token	= params[:token].to_str
			user_id 		= params[:user_id].to_str
			dev_id			= params[:dev_id].to_str
			@user_info 		= JSON.parse params[:u_info];
			oauth_str 		= 'OAuth="'+access_token+'"'
			headers = { 
		        'User-Agent': 'happn/19.12.0 android/16',
				'Accept-Language': 'en-US;q=1,en;q=0.75',
				'Content-Type': 'application/json; charset=UTF-8;',
				'Authorization': oauth_str,
				'Host': 'api.happn.fr',
				'X-Happn-DID': dev_id
		    }

	      	options = {	
	      		'job': @user_info['job'],
	      		'workplace': @user_info['workplace'],
	      		'school': @user_info['school'],
	      		'about': @user_info['about']
			}	

			base_uri 		= 'https://api.happn.fr/api/users/'+user_id
			
			
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

	def get_user_setting
		# Get user Setting
		#
		#  IN     token  		: Happn Access Token
		#         user_id		: user_id from Happn
		#         dev_id		: RegisterdDevice ID 
		#  Return
		#         jsonObj 		: Result

		if (not params.has_key?(:token)) || (not params.has_key?(:user_id))|| (not params.has_key?(:dev_id))
			@happnInfo = [{"Result": "failed","jsonObj": "Token/UserID/DeviceID ERROR"}]
		else
			access_token	= params[:token].to_str
			user_id 		= params[:user_id].to_str
			dev_id			= params[:dev_id].to_str
			oauth_str 		= 'OAuth="'+access_token+'"'
			headers = { 
		        'User-Agent': 'happn/19.12.0 android/16',
				'Accept-Language': 'en-US;q=1,en;q=0.75',
				'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
				'Authorization': oauth_str,
				'Host': 'api.happn.fr',
				'X-Happn-DID': dev_id
		    }

	      	options = {	
	      		
			}	

			base_uri 		= 'https://api.happn.fr/api/users/'+user_id+'?fields=matching_preferences,notification_settings'
			
			
		    response = self.class.get(base_uri.to_str,
		    	:body=> options,
		      	:headers => headers)
		    if response.success?
		      	@happnInfo = [{"Result": "success","jsonObj": response}]
			else
			  	@happnInfo = [{"Result": "failed","jsonObj": response}]
			end	  
		end
	end
end