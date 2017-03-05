aggregate_dating = angular.module('aggregate_dating',[
  	'templates',
  	'ngRoute',
    'ngResource',
  	'controllers',
  	'facebook',
    'ngFileUpload'
])

aggregate_dating.config([ '$routeProvider',
  	($routeProvider)->
    	$routeProvider
      	.when('/',
          templateUrl: "index.html"
          controller: 'CMBController'
        )
        .when('/happn',
          templateUrl: "happn.html"
          controller: 'HappenController'
        )
])

aggregate_dating.config([ '$facebookProvider',
 	($facebookProvider)->
      	$facebookProvider
        .init({
            # appId: '349609268750448'  # TEST App ID
            appId: '273145509408031'  #  CMB Facebook App ID
        })
])

aggregate_dating.config(['$qProvider', 
  ($qProvider)->
    $qProvider.errorOnUnhandledRejections(false);
])


cmbInfo = []

appID = {'cmb': '273145509408031','happn': '247294518656661'}

controllers = angular.module('controllers',[])
controllers.controller("CMBController", [ '$scope','$rootScope', '$routeParams', '$location', '$facebook', '$http', '$resource', 'Upload'
  ($scope,$rootScope,$routeParams,$location,$facebook,$http,$resource, Upload)->
    
    $scope.fblogin_flag = false
    $scope.login_flag = false
    $scope.fbToken = ""
    $rootScope.cmb_chat_step = 0  # 0: NONE
                              # 1: Connected
                              # 2: Authorized
    $rootScope.cmb_chat_my_id = 0  # my_chat_profile_id
    $rootScope.webSocket = {};
    $rootScope.webSocket1 = {};
    #if(not $scope.fbToken?)

    # assign token fetched manually
    # $scope.fbToken = 'EAAD4bKUPbR8BAJhN2LdnSbEgWuoo3hUDlQD7b2Ypg6h3lhYYodKswOvvN5IWQJz9gsBN1wIrGJbH3Ysrg2K920wnhfAIxkSzIA17KxNesOvCpVl7026ZAF43wFwcEG2Ahzk11fJ99FxX9j85mZAiFZBhiNZClG456n6Wq8y6YFbRK9ODII2HGj4OpRiy2hpMZCvdIqsV8INMorQdSPE1p'
    
    # loginFacebook function which use Javascript SDK

    # $scope.loginFacebook = ->
    #   #   Login with FaceBook           
    #   $scope.fblogin_flag = true
    #   # $facebook.login(scope: 'public_profile, email, user_friends, user_birthday, user_photos').then ((response) ->
    #   $facebook.login(scope: 'public_profile, email, user_friends').then ((response) ->
    #     authtoken = response.authResponse.accessToken
    #     console.log 'FB Login Success', authtoken
    #     console.log response.authResponse
    #     $scope.fbToken = authtoken
    #     $scope.fbUserID = response.authResponse.userID
    #     # $scope.loginCMB(authtoken)
    #     $scope.fblogin_flag = false
    # ), (response) ->
    #     console.log 'FB Login Error', response

    $scope.loginFacebook = (network)->
      FBLogin = $resource('/home/fblogin', { format: 'json' })
      FBLogin.query( (results) -> 
        
        console.log 'data OK'   
      )

      # config = headers: 'User-Agent': 'Mozilla/5.0 (Linux; Android 4.4.4; Samsung Galaxy S4 - 4.4.4 - API 19 - 1080x1920 Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/33.0.0.0 Mobile Safari/537.36', 'X-Requested-With': 'com.coffeemeetsbagel'   #, 'Client': 'Android', 'Cache-Control': 'no-cache', 'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8;', 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Headers': 'X-Requested-With, Content-Type, Authorization', 'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS'
      # # config = headers: 'Content-Type': undefined, 'Cache-Control': 'no-cache'

      # data = {};
      # $http.get('https://m.facebook.com/v2.7/dialog/oauth?client_id=273145509408031&e2e={"init":1478551666628}&sdk=android-4.14.0&scope=user_friends,email,user_photos,user_birthday,user_education_history&default_audience=friends&redirect_uri=fbconnect://success&auth_type=rerequest&display=touch&response_type=token,signed_request&return_scopes=true&state={"0_auth_logger_id":"0e7bd8c6-4067-419e-b44a-d1e676f1fcc9","3_method":"web_view"}', data, config).then((data, status, headers, config) ->
      #   $scope.loginDataResponse = data
      #   console.log 'LOGIN Facebook Success', $scope.loginDataResponse
        
      # ).error (data, status, header, config) ->
      #   $scope.ResponseDetails = 'Data: ' + data + '<hr />status: ' + status + '<hr />headers: ' + header + '<hr />config: ' + config
      #   console.log 'LOGIN CMB Error', $scope.ResponseDetails

      # openUrl = '/auth/facebook?appid=273145509408031'
      # openUrl = '/'
      openUrl = 'https://www.facebook.com/dialog/oauth?client_id=' + appID[network] + '&redirect_uri=fbconnect://success&scope=user_friends,email,user_photos,user_birthday,user_education_history&response_type=token'
      
      window.$windowScope = $scope
      window.popup = window.open openUrl, 'Authenticate Account', 'width=800, height=500'
      # window.popup.addEventListener 'load', onHashChange, false

      window.popup.addEventListener 'load', (->
        console.log 'ALLERTT'
        return
      ), true 

      window.popup.addEventListener 'hashchange', (->
        console.log 'ALLERTT1'
        return
      ), true 

      window.popup.addEventListener 'click', (->
        console.log 'ALLERTT2'
        window.popup.close
        return
      ), true 

      window.popup.addEventListener 'submit', (->
        console.log 'ALLERTT3'
        return
      ), true 


      # window.onhashchange = onHashChange
      # try
      #   window.opener.$windowScope.handlePopupAuthentication 'facebook', 'account'
      # catch err
      # window.close();



      console.log 'END OF LOGIN FACEBOOK'

    # $scope.onHashChange = ->
      # console.log 'ON HASH CHANGE'
      # return

    $scope.handlePopupAuthentication = (network, account) ->

      #Note: using $scope.$apply wrapping
      #the window popup will call this 
      #and is unwatched func 
      #so we need to wrap
      $scope.$apply ->
        $scope.applyNetwork network, account
        return

    $scope.setFBToken = () ->
      $scope.fbToken = $scope.user_fbToken

    $scope.loginCMB = ->
      #login with CMB
      #CURL commands:
      # 1. curl https://api.coffeemeetsbagel.com/profile/me -H "App-version: 779" -H
      
      # $scope.loginFacebook().then ((response) ->    #commented because we use manually set FBToken
      #   if $scope.fblogin_flag == true
      #     return  

        $scope.login_flag = true;
        $scope.cmbInfo = [] 
        Cmb = $resource('/cmb', { format: 'json' })
        Cmb.query(fbToken: $scope.fbToken , (results) -> 
          $scope.cmbInfo = results
          $scope.sessionid = results[0].sessionid
          $scope.login_flag = false
        )
        console.log 'loginFacebook Halt'
      # )

      
    $scope.setMyProfileProcess1 = ->
      # Set values and Send to Server
      $scope.profile_flag = true
      $scope.user = {}
      $scope.user.id = $scope.userid
      $scope.user.language_code = "en"

      Cmb = $resource('/cmb/set_profileprocess1', { format: 'json' })
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, user: $scope.user , (results) -> 
        $scope.profileProcessResult = results
        $scope.profile_flag = false
        console.log 'data OK'   
      )

    $scope.setMyProfileProcess2 = ->
      # Set values and Send to Server
      $scope.profile_flag = true
      $scope.user = {}
      $scope.user.id = $scope.userid
      $scope.user.gender = "m"
      $scope.user.birthday = "1997-07-29 00:00:00"
      $scope.user.criteria__gender = "f"
      $scope.user.user__email = "someemail@somemailserver.com"

      Cmb = $resource('/cmb/set_profileprocess2', { format: 'json' })
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, user: $scope.user , (results) -> 
        $scope.profileProcessResult = results
        $scope.profile_flag = false
        console.log 'data OK'
      )

    $scope.setMyProfileProcess3 = ->
      # Set values and Send to Server
      $scope.profile_flag = true
      $scope.user = {}
      $scope.user.id = $scope.userid
      $scope.user.location = "Kiev, UA"

      Cmb = $resource('/cmb/set_profileprocess3', { format: 'json' })
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, user: $scope.user , (results) -> 
        $scope.profileProcessResult = results
        $scope.profile_flag = false
        console.log 'data OK'   
      )

    $scope.getMyProfile = ->
      # Set my profile
      # Check Input values
      if(not $scope.fbToken?)
        alert "Please Click 'Login with Facebook'."
        return
      # Set values and Send to Server
      $scope.get_profile_flag = true

      Cmb = $resource('/cmb/get_profile', { format: 'json' })
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, (results) -> 
        $scope.profileInfo = results        
        $scope.userid = results[0].jsonObj.id
        $scope.user_language_code = results[0].jsonObj.language_code
        $scope.user_gender = results[0].jsonObj.gender
        $scope.user_name = results[0].jsonObj.full_name
        $scope.user_email = results[0].jsonObj.user__email        
        $scope.user_criteria_gender = results[0].jsonObj.criteria__gender        
        $scope.user_birthday = new Date(results[0].jsonObj.birthday)
        $scope.user_location = results[0].jsonObj.location
        $scope.firebaseToken = results[0].jsonObj.firebase_token
        $scope.get_profile_flag = false         
      )
      
    
    $scope.setMyProfile = ->
      # Set my profile
      # Check Input values
      if(not $scope.fbToken?)
        alert "Please Click 'Login with Facebook'."
        return
      if(not $scope.user_name?)
        alert "Please Input 'User Name'."
        return
      if(not $scope.user_gender?)
        alert "Please Input 'User Gender'."
        return
      if($scope.user_gender!= "f" && $scope.user_gender!= "m")
        alert "'User Gender' must be 'm/f'."
        return
      if(not $scope.user_criteria_gender?)
        alert "Please Input 'Criteria Gender'."
        return
      if($scope.user_criteria_gender!= "f" && $scope.user_criteria_gender!= "m")
        alert "'Criteria Gender' must be 'm/f'."
        return
      if(not $scope.user_email?)
        alert "Please Input 'User Email'."
        return
      # Set values and Send to Server
      $scope.profile_flag = true
      $scope.user = {}
      $scope.user.language_code = $scope.user_language_code
      $scope.user.name = $scope.user_name
      $scope.user.id = $scope.userid
      $scope.user.gender = $scope.user_gender
      $scope.user.birthday = $scope.user_birthday
      $scope.user.email = $scope.user_email
      $scope.user.criteria_gender = $scope.user_criteria_gender 
      $scope.user.location = $scope.user_location

      Cmb = $resource('/cmb/set_profile', { format: 'json' })
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, user: $scope.user , (results) -> 
        $scope.setProfileInfo = results
        $scope.profile_flag = false
        console.log 'data OK'   
      )
      
    $scope.getBagels = ->
      if(not $scope.fbToken?)
        alert "Please Click 'Login with Facebook'."
        return     
      $scope.bagels_flag = true
      $scope.BagelsInfo = [] 
      Cmb = $resource('/cmb/get_bagels', { format: 'json' })
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, (results) -> 
        $scope.BagelsInfo = results
        $scope.BagelInfo = {}
        $scope.BagelInfo.hex_id = results[0].jsonObj.current_token
        $scope.BagelInfo.cursor_after = results[0].jsonObj.cursor_after
        $scope.BagelInfo.cursor_before = results[0].jsonObj.cursor_before
        $scope.BagelInfo.more_after = results[0].jsonObj.more_after
        $scope.BagelInfo.more_before = results[0].jsonObj.more_before
        $scope.bagels_flag = false
        console.log 'Bagles OK'   
      )
      
    $scope.getBagelsHistory = ->
      if(not $scope.fbToken?)
        alert "Please Click 'Login with Facebook'."
        return    
         
      if(not $scope.BagelInfo?) || (not $scope.BagelInfo.hex_id?) 
        alert "Please Click 'Set Bagels'."
        return    
      $scope.bagels_history_flag = true
      $scope.BagelsList = [] 
      Cmb = $resource('/cmb/get_bagels_history', { format: 'json' })
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, bagel: $scope.BagelInfo, (results) -> 
        $scope.BagelsList = results    
        $scope.bagels_history_flag = false   
        console.log 'Bagles History OK'   
      )

    $scope.getResources = ->
      $scope.get_resources_flag = true
      Cmb = $resource('/cmb/get_resources', { format: 'json' })
      $scope.ResourceInfo = [] 
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, (results) -> 
        $scope.ResourceInfo = results
        $scope.get_resources_flag = false
        console.log 'ResourceOk'
      )

    $scope.sendBatches = ->
      if(not $scope.fbToken?)
        alert "Please Click 'Login with Facebook'."
        return

      # if(not $scope.BagelInfo?) || (not $scope.BagelInfo.hex_id?) 
      #   alert "Please Click 'Set Bagels'."
      #   return
      $scope.batches_flag = true
      Cmb = $resource('/cmb/send_batch', { format: 'json' })
      $scope.BatchesInfo = []
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, (results) -> 
        $scope.BatchesInfo = results
        $scope.batches_flag = false
        console.log 'BatchOk'
      )

    $scope.photolabs = ->
      if(not $scope.fbToken?)
        alert "Please Click 'Login with Facebook'."
        return
      $scope.photolabs_flag = true
      $scope.PhotoLabs = []
      Cmb = $resource('/cmb/get_photolabs', { format: 'json' })
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, (results) -> 
        $scope.PhotoLabs = results
        $scope.photolabs_flag = false
        console.log 'get_photoLabs'
      )

    $scope.giveTake = ->
      if(not $scope.fbToken?)
        alert "Please Click 'Login with Facebook'."
        return
      $scope.give_take_flag = true
      $scope.girl_id = '2244848'
      $scope.GiveTaskResult = []
      Cmb = $resource('/cmb/give_take', { format: 'json' })      
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, customer_id: $scope.girl_id, (results) -> 
        $scope.GiveTaskResult = results
        $scope.give_take_flag = false
        console.log 'giveTake'
      )

    $scope.purchase = ->
      if(not $scope.fbToken?)
        alert "Please Click 'Login with Facebook'."
        return
      $scope.girl_id = '2244848'
      if(not $scope.item_count?)
        alert "Please Input 'Item Count'."
        return
      if(not $scope.item_name?)
        alert "Please Input 'Item Name'."
        return
      if(not $scope.expected_price?)
        alert "Please Input 'expected_price'."
        return
      if(not $scope.give_ten_id?)
        alert "Please Input 'Given ten id'."
        return
      $scope.purchase_flag = true
      $scope.Purchase = {}
      $scope.Purchase.item_name = $scope.item_name
      $scope.Purchase.item_count = $scope.item_count
      $scope.Purchase.expected_price = $scope.expected_price
      $scope.Purchase.give_ten_id = $scope.give_ten_id
      $scope.PurchaseResult = []
      Cmb = $resource('/cmb/purchase', { format: 'json' })      
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, purchase: $scope.Purchase, (results) -> 
        $scope.PurchaseResult = results
        $scope.purchase_flag = false
        console.log 'PurchaseOK'
      )

    $scope.report = ->
      if(not $scope.fbToken?)
        alert "Please Click 'Login with Facebook'."
        return
      Cmb = $resource('/cmb/report', { format: 'json' })      
      $scope.report_num = "4"
      $scope.report_flag = true
      $scope.ReportResult = []
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, (results) -> 
        $scope.ReportResult = results
        $scope.report_flag = false
        console.log 'Report'
      )
    $scope.get_bundary_id = ->
      uniqueId = (length=8) ->
        id = ""
        id += Math.random().toString(36).substr(2) while id.length < length
        id.substr 0, length
      #var boundary_id = uniqueId(8) + "-" + uniqueId(4) + "-" + + uniqueId(4) + "-" + uniqueId(4) + "-" + uniqueId(12) 
      b_1 = uniqueId(8)
      b_2 = uniqueId(4)
      b_3 = uniqueId(4)
      b_4 = uniqueId(4)
      b_5 = uniqueId(12)
      #$scope.boundary_id = "#{b_1}-#{b_2}-#{b_3}-#{b_4}-#{b_5}"      
      return "#{b_1}-#{b_2}-#{b_3}-#{b_4}-#{b_5}"

    $scope.photo = ->           
      boundary_id = $scope.get_bundary_id()
      if(not $scope.fbToken?)
        alert "Please Click 'Login with Facebook'."
        return
      if(not $scope.photo_position?)
        alert "Please Input Photo Position."
        return
      if(not $scope.photo_caption?)
        alert "Please Input Photo Caption."
        return
      #$file_name      
      #$file_photo_position
      #$file_photo_caption
    $scope.pickimg = (file) ->
      if(not $scope.fbToken?)
        alert "Please Click 'Login with Facebook'."
        return
      #$file_name 
      Cmb = $resource('/cmb/msg_login', { format: 'json' })      
      $scope.report_num = "4"
      $scope.report_flag = true
      $scope.ReportResult = []
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, (results) -> 
        $scope.ReportResult = results
        $scope.report_flag = false
        console.log 'Report'
      )    

      # upload on file select or drop
      # this is angular file upload
      # 
    $scope.upload = (file) ->
      console.log file
      Upload.upload({
          url: 'https://api.coffeemeetsbagel.com/photo',
          data: {"file": file, 'position': $scope.file_photo_position, "caption": $scope.file_photo_caption},
          headers: {
            "AppStore-Version": "3.4.1.779",
            "App-Version": "779",
            "Client": "Android",
            "Content-Type": "multipart/form-data",
            "Access-Control-Allow-Origin": "*",
            "Facebook-Auth-Token": $scope.fbToken,
            "Cookie": "sessionid="+$scope.sessionid 
          }
      }).then((resp) ->
          console.log 'Success ' + resp.config.data.file.name + 'uploaded. Response: ' + resp.data
      , (resp) ->
          console.log('Error status: ' + resp.status);
      , (evt) ->
          $scope.progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
          console.log 'progress: ' + $scope.progressPercentage + '% ' + evt.config.data.file.name
      )
    $scope.loginFacebookForTinder = ->           
      if(not $scope.fbToken?)
        $scope.tinder_login_flag = true
        $facebook.login(scope: 'email').then ((response) ->
          authtoken = response.authResponse.accessToken
          console.log response.authResponse
          $scope.fbToken = authtoken
          $scope.fbUserID = response.authResponse.userID  
          $scope.loginTinder()               
        ), (response) ->
            console.log 'FB Login Error', response
      else
        $scope.loginTinder()
    $scope.loginTinder = ->
      $scope.tinderInfo = [] 
      Tinder = $resource('/tinder', { format: 'json' })
      Tinder.query(fbToken: $scope.fbToken, fbUserID: $scope.fbUserID , (results) -> 
        $scope.tinderInfo = results        
        $scope.tinder_login_flag = false
      )
    
    $scope.login_Chat = ->
      if(not $scope.sessionid?)
        alert "Please Click 'Login with Facebook'."
        return
      #cmb = $resource('/cmb/chat_message', { format: 'json' })
      #cmb.query(firebaseToken: $scope.firebaseToken, (results) -> 
      #  $scope.tinderInfo = results        
      #  $scope.tinder_login_flag = false
      #)
      if($rootScope.cmb_chat_step >= 2)
        alert "You are authorized yet."
        return
      $rootScope.chat_login_flag = true
      
      Cmb = $resource('/cmb/get_profile', { format: 'json' })
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, (results) -> 
        $scope.profileInfo = results        
        $scope.userid = results[0].jsonObj.id
        $scope.user_language_code = results[0].jsonObj.language_code
        $scope.user_gender = results[0].jsonObj.gender
        $scope.user_name = results[0].jsonObj.full_name
        $scope.user_email = results[0].jsonObj.user__email        
        $scope.user_criteria_gender = results[0].jsonObj.criteria__gender        
        $scope.user_birthday = new Date(results[0].jsonObj.birthday)
        $scope.user_location = results[0].jsonObj.location
        $scope.firebaseToken = results[0].jsonObj.firebase_token
        
        $rootScope.authData = {  
             "d":{  
                "b":{  
                   "cred": $scope.firebaseToken
                },
                "r":0,
                "a":"auth"
             },
             "t":"d"
          }
        
        $rootScope.webSocket1 = new WebSocket('wss://cmb-prod.firebaseio.com/.ws?ns=cmb-prod&v=5')
        
        $rootScope.webSocket1.onmessage = (e) ->  
          data = JSON.parse(e.data)
          console.log(data);
          $rootScope.webSocket1.close()   
          $rootScope.webSocket= new WebSocket('wss://'+data.d.d+'/.ws?ns=cmb-prod&v=5')
          $rootScope.cmb_chat_step = 0         # connected
          $rootScope.webSocket.onopen = ->
            #$scope.webSocket.send $scope.authData
            # Send the message 'Ping' to the server
            return
          $rootScope.webSocket.onerror = (error) ->
            console.log 'WebSocket Error ' + error
            return

              # Log messages from the server
          $rootScope.webSocket.onmessage = (e) -> 
            console.log e.data    
            data = JSON.parse(e.data)                
            if($rootScope.cmb_chat_step == 0)  
              auth_data = JSON.stringify($rootScope.authData)            
              $rootScope.cmb_chat_step = 1         # connected
              $rootScope.webSocket.send auth_data  # send firebase_token to firebase server.  
            else if ($rootScope.cmb_chat_step == 1)
              $rootScope.cmb_chat_step = 2
              $rootScope.cmb_chat_my_id = data.d.b.d.auth.profile_id
              $rootScope.chat_login_flag = false
              $rootScope.ChatResult = data   
              console.log "my_id : " + $rootScope.cmb_chat_my_id

            else if ($rootScope.cmb_chat_step == 3)
              if(data.d.b.s != "ok")                
                $rootScope.LastMsg = data 
            else if ($rootScope.cmb_chat_step == 4)
              # get message result
              if(data.d.b.s != "ok")
                $rootScope.ChatMessageList = data 
            else if ($rootScope.cmb_chat_step == 5)
              #send Message result
              if(data.d.b.s != "ok")
                $rootScope.SendResult = data 
            return
      )
      
      

    $scope.list_Chat = ->
      
      if(not $scope.fbToken?)
        alert "Please Click 'Login with Facebook'."
        return
      #$file_name 
      Cmb = $resource('/cmb/get_chat_list', { format: 'json' })      
      
      $scope.chat_list_flag = true
      $scope.ChatList = []
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, (results) -> 
        chat_list = results[0].jsonObj.results
        $scope.chat_list_flag = false
        for d,i in chat_list          
          if(d.couple_id == null) 
            continue
          console.log d
          $scope.ChatList.push d.couple_id
        console.log $scope.ChatList.length
      )   
    $scope.get_last_message = ->
      if( $rootScope.cmb_chat_step < 2)
        alert "Please Click 'Chat Login'."
        return
      if( not $rootScope.msg_id?)
        alert "Please input Partner ID."
        return
      tmp_url = "/chats/"+$scope.msg_id+"/details/"+$rootScope.cmb_chat_my_id
      $scope.get_last_msg_packet = {  
         "d": {  
            "b": {  
               "h": "",
               "p": tmp_url
            },
            "r": 3,
            "a": "q"
         },
         "t": "d"
      }
      get_last_msg_data = JSON.stringify($scope.get_last_msg_packet)            
      $rootScope.cmb_chat_step = 3         # connected
      $rootScope.webSocket.send get_last_msg_data  # send firebase_token to firebase server. 
      
    $scope.get_chat_message = ->
      if( $rootScope.cmb_chat_step < 2)
        alert "Please Click 'Chat Login'."
        return
      if( not $scope.partner_id?)
        alert "Please input Partner ID."
        return
      tmp_url = "/chats/"+$scope.partner_id+"/messages"
      $scope.get_msg_packet = {  
         "d":{  
            "b":{  
               "h":"",
               "q":{  
                  "vf":"r",
                  "l":30
               },
               "t":1,
               "p":tmp_url
            },
            "r":2,
            "a":"q"
         },
         "t":"d"
      }
      console.log $rootScope.webSocket
      console.log $scope.get_msg_packet
      get_msg_data = JSON.stringify($scope.get_msg_packet)            
      $rootScope.cmb_chat_step = 4         # connected
      $rootScope.webSocket.send get_msg_data  # send firebase_token to firebase server. 

    $scope.send_message_aaa = ->
      d = new Date()
      n = d.getTime()
      hash_key = $scope.get_hash_key(n)
      nPriority = n / 1000000000000;
      my_num = Math.floor(Math.random() *256) 
      hex_string = my_num.toString(16)
      if(hex_string.length == 0)
        hex_string = "00"
      else if(hex_string.length == 1)
        hex_string = "0" + hex_string

      nPriority = nPriority.toString() + hex_string
      year = d.getFullYear()
      month = (d.getMonth() + 1)
      day = d.getDate()
      h = d.getTime()
      m = d.getMin
      data_sent = d.getFullYear() + "-" + 
      ("00" + (d.getMonth() + 1)).slice(-2) + "-" + 
      ("00" + d.getDate()).slice(-2) + " " +       
      ("00" + d.getHours()).slice(-2) + ":" + 
      ("00" + d.getMinutes()).slice(-2) + ":" + 
      ("00" + d.getSeconds()).slice(-2)
      tmp_url =  "/chats/"+$scope.partner_id+"/messages/"+hash_key
      $scope.send_msg_packet = {  
        "d":{  
          "b":{  
             "d":{  
                ".priority":nPriority,
                "senderID":$rootScope.cmb_chat_my_id,
                "dateSent":data_sent,
                "text":$scope.send_msg
             },
             "p":tmp_url
          },
          "r":30,
          "a":"p"
        },
        "t":"d"
      }
      send_msg_packet = JSON.stringify($scope.send_msg_packet)            
      $rootScope.cmb_chat_step = 5         # send message
      $rootScope.webSocket.send send_msg_packet  # send firebase_token to firebase server. 
      
      return

    $scope.get_hash_key = (miliseconds)->
      original_str = "-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz"
      str = "";
      n = 0;
      i = 7
      temp_time= miliseconds
      while i >= 0
        n = temp_time % 64;
        str = str + original_str.charAt(n)
        temp_time /= 64
        temp_time = parseInt(temp_time)
        i--
      if(temp_time == 0)
        i = 0
        while(i < 12)
          n = Math.floor(Math.random() * 64) 
          str = str + original_str.charAt(n)
          i++
      return str

    
      
  ])

controllers.controller("HappenController", [ '$scope', '$routeParams', '$location', '$facebook', '$http', '$resource', 'Upload'
  ($scope,$routeParams,$location,$facebook,$http,$resource, Upload)->
    
    $scope.fblogin_flag = false
    $scope.login_happn_flag = false
    #if(not $scope.fbToken?)
    $scope.happnInfo = []
    $scope.user_client_id       = "FUE-idSEP-f7AqCyuMcPr2K-1iCIU_YlvK-M-im3c"
    $scope.user_client_secret   = "brGoHSwZsPjJ-lBk0HqEXVtb3UFu-y5l_JcOjD-Ekv"
    $scope.user_android_id      = "a363d47528091227"
    $scope.user_fbToken_for_happn = "EAADg6b3wfpUBANj46Lu4CPmvTYPUt5NUqPxjMRsYiwFX1yi9WpqRXXDuAnuRDIpwulRVH4NZBMNi41G3gNykaIgzSsTZCHaFA9Q9ysvm9p7eBcqzrGBpnDEJiDym0K0pIP17RbZAwW4JZC1n7Vzhj1GuXPBcw5AZD"
    $scope.prospects = []
    $scope.offset = 0
    $scope.loginFacebook = (network)->
      
      # config = headers: 'User-Agent': 'Mozilla/5.0 (Linux; Android 4.4.4; Samsung Galaxy S4 - 4.4.4 - API 19 - 1080x1920 Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/33.0.0.0 Mobile Safari/537.36', 'X-Requested-With': 'com.coffeemeetsbagel'   #, 'Client': 'Android', 'Cache-Control': 'no-cache', 'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8;', 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Headers': 'X-Requested-With, Content-Type, Authorization', 'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS'
      # # config = headers: 'Content-Type': undefined, 'Cache-Control': 'no-cache'

      # data = {};
      # $http.get('https://m.facebook.com/v2.7/dialog/oauth?client_id=273145509408031&e2e={"init":1478551666628}&sdk=android-4.14.0&scope=user_friends,email,user_photos,user_birthday,user_education_history&default_audience=friends&redirect_uri=fbconnect://success&auth_type=rerequest&display=touch&response_type=token,signed_request&return_scopes=true&state={"0_auth_logger_id":"0e7bd8c6-4067-419e-b44a-d1e676f1fcc9","3_method":"web_view"}', data, config).then((data, status, headers, config) ->
      #   $scope.loginDataResponse = data
      #   console.log 'LOGIN Facebook Success', $scope.loginDataResponse
        
      # ).error (data, status, header, config) ->
      #   $scope.ResponseDetails = 'Data: ' + data + '<hr />status: ' + status + '<hr />headers: ' + header + '<hr />config: ' + config
      #   console.log 'LOGIN CMB Error', $scope.ResponseDetails

      # openUrl = '/auth/facebook?appid=273145509408031'
      # openUrl = '/'
      openUrl = 'https://www.facebook.com/dialog/oauth?client_id=' + appID[network] + '&redirect_uri=fbconnect://success&scope=user_friends,email,user_photos,user_birthday,user_education_history&response_type=token'
      console.log openUrl
      window.$windowScope = $scope
      window.popup = window.open openUrl, 'Authenticate Account', 'width=800, height=500'
      # window.popup.addEventListener 'load', onHashChange, false

      window.popup.addEventListener 'load', (->
        console.log 'ALLERTT'
        return
      ), true 

      window.popup.addEventListener 'hashchange', (->
        console.log 'ALLERTT1'
        return
      ), true 

      window.popup.addEventListener 'click', (->
        console.log 'ALLERTT2'
        window.popup.close
        return
      ), true 

      window.popup.addEventListener 'submit', (->
        console.log 'ALLERTT3'
        return
      ), true 


      # window.onhashchange = onHashChange
      # try
      #   window.opener.$windowScope.handlePopupAuthentication 'facebook', 'account'
      # catch err
      # window.close();



      console.log 'END OF LOGIN FACEBOOK'

    # $scope.onHashChange = ->
      # console.log 'ON HASH CHANGE'
      # return

    $scope.handlePopupAuthentication = (network, account) ->

      #Note: using $scope.$apply wrapping
      #the window popup will call this 
      #and is unwatched func 
      #so we need to wrap
      $scope.$apply ->
        $scope.applyNetwork network, account
        return

    $scope.setFBTokenForHappn = ->
      $scope.fbTokenForHappn      = $scope.user_fbToken_for_happn
      $scope.clientIDForHappn     = $scope.user_client_id
      $scope.clientSecretForHappn = $scope.user_client_secret
      $scope.clientAndroidID      = $scope.user_android_id

    $scope.loginHappn = ->
      #login with Happn
      if($scope.fbTokenForHappn == undefined || $scope.fbTokenForHappn == "")
        alert("Please input FB Token")
        return
      $scope.login_happn_flag = true
      Happn = $resource('/happn', { format: 'json' })
      Happn.query(fbToken: $scope.fbTokenForHappn, client_id: $scope.clientIDForHappn, client_sercret: $scope.clientSecretForHappn , (results) -> 
        $scope.happnInfo = results[0].jsonObj
        $scope.login_happn_flag = false
      )
    $scope.MutualFriends = ->
      if($scope.happnInfo.access_token == undefined || $scope.happnInfo.access_token == "")
        alert("Please Login with Happn")
        return      
      if($scope.user_fb_id == undefined)
        alert "Please input user_fb_id."
        return
      access_token = $scope.happnInfo.access_token
      $scope.mutual_friends_flag = true
      console.log access_token
      console.log $scope.fbTokenForHappn
      Happn = $resource('/happn/mutual_friends', { format: 'json' })
      Happn.query(token: access_token, fb_token: $scope.fbTokenForHappn, user_fb_id: $scope.user_fb_id, (results) -> 
        
        $scope.happnInfo.mutual_info = results[0].jsonObj
        $scope.mutual_friends_flag = false
      )
    $scope.RegisterDevice = ->
      #register device
      access_token = $scope.happnInfo.access_token
      userid = $scope.happnInfo.user_id
      if(access_token == undefined || userid == undefined)
        alert "Please Happn Login with Facebook."
        return
      
      $scope.register_device_flag = true
      Happn = $resource('/happn/register_device', { format: 'json' })
      Happn.query(token: access_token, user_id: userid, android_id: $scope.clientAndroidID, (results) -> 
        
        $scope.happnInfo.device = results[0].jsonObj.data
        $scope.register_device_flag = false
      )
    $scope.SetProfileFirst = ->
      access_token = $scope.happnInfo.access_token
      userid = $scope.happnInfo.user_id
      if(access_token == undefined || userid == undefined)
        alert "Please Happn Login with Facebook."
        return
      $scope.profile_first_flag = true
      Happn = $resource('/happn/set_profile_first', { format: 'json' })
      Happn.query(token: access_token, user_id: userid , (results) -> 
        
        $scope.happnInfo.profile = results[0].jsonObj.data
        $scope.profile_first_flag = false
      )
    $scope.RefreshToken = ->
      refreshtoken = $scope.happnInfo.refresh_token      
      
      if($scope.happnInfo.device == undefined)
        alert "Please Register Device."
        return
      devid = $scope.happnInfo.device.id
      if(refreshtoken == undefined )
        alert "Please Happn Login with Facebook."
        return
      $scope.refresh_token_flag = true
      Happn = $resource('/happn/refresh_token', { format: 'json' })
      
      Happn.query(refresh_token: refreshtoken, dev_id: devid, client_id: $scope.clientIDForHappn, client_secret: $scope.clientSecretForHappn, (results) -> 
        
        $scope.happnInfo.access_token = results[0].jsonObj.access_token
        $scope.happnInfo.refresh_token = results[0].jsonObj.refresh_token
        $scope.refresh_token_flag = false
      )
    $scope.DiscoverNewProspect = ->
      access_token = $scope.happnInfo.access_token
      userid = $scope.happnInfo.user_id
      $scope.offset = 0
      $scope.prospects = []
      if($scope.happnInfo.device == undefined)
        alert "Please Register Device."
        return
      devid = $scope.happnInfo.device.id
      if(access_token == undefined || userid == undefined )
        alert "Please Happn Login with Facebook."
        return
      $scope.loadNewProspect()
    $scope.loadNewProspect = ->
      access_token = $scope.happnInfo.access_token
      userid = $scope.happnInfo.user_id

      devid = $scope.happnInfo.device.id
      $scope.discover_prospect_flag = true
      Happn = $resource('/happn/discover_new_prospects', { format: 'json' })
      console.log $scope.offset
      Happn.query(token: access_token, user_id: userid, dev_id: devid, offset: $scope.offset, (results) ->         
        $scope.happnInfo.new_prospects = results[0].jsonObj;        
        for d,i in $scope.happnInfo.new_prospects.data           
          user_string =  d.notifier.first_name + '(' + d.notifier.age + ', ' +d.notifier.my_relation+ ')'
          console.log user_string
          if(d.notifier.my_relation == 0)
            $scope.new_prospects.push d


            #$scope.new_prospects.push(user_string)
          #$scope.new_prospects.push d.notifier.first_name + '('+d.notifier.age+')'
        console.log $scope.new_prospects.length
        if($scope.new_prospects.length < 16)
          $scope.offset = $scope.offset + 16
          $scope.loadNewProspect()
        $scope.discover_prospect_flag = false
      )
    $scope.GetChatList = ->
      access_token = $scope.happnInfo.access_token
      userid = $scope.happnInfo.user_id
      
      if($scope.happnInfo.device == undefined)
        alert "Please Register Device."
        return
      devid = $scope.happnInfo.device.id
      if(access_token == undefined || userid == undefined )
        alert "Please Happn Login with Facebook."
        return
      $scope.chat_list_flag = true
      Happn = $resource('/happn/get_list_of_chats', { format: 'json' })
      
      Happn.query(token: access_token, user_id: userid, dev_id: devid, (results) ->         
        $scope.happnInfo.chat_list = results[0].jsonObj;
        $scope.chat_list_flag = false
      )

    $scope.GetChatMsg = ->
      if($scope.msg_id == undefined)
        alert "Please input MessageID"
        return
      access_token = $scope.happnInfo.access_token
      
      if($scope.happnInfo.device == undefined)
        alert "Please Register Device."
        return
      devid = $scope.happnInfo.device.id
      if(access_token == undefined  )
        alert "Please Happn Login with Facebook."
        return
      $scope.chat_msg_flag = true
      Happn = $resource('/happn/get_conversation_msg', { format: 'json' })
      
      Happn.query(token: access_token, dev_id: devid,msg_id: $scope.msg_id, (results) ->         
        $scope.happnInfo.messages = results[0].jsonObj
        $scope.chat_msg_flag = false
      )

    $scope.SendChatMsg = ->
      if($scope.msg_id == undefined)
        alert "Please input MessageID"
        return
      if($scope.msg == undefined)
        alert "Please input Message"
        return
      access_token = $scope.happnInfo.access_token
      
      if($scope.happnInfo.device == undefined)
        alert "Please Register Device."
        return
      devid = $scope.happnInfo.device.id
      if(access_token == undefined  )
        alert "Please Happn Login with Facebook."
        return
      $scope.send_msg_flag = true
      Happn = $resource('/happn/send_conversation_msg', { format: 'json' })
      
      Happn.query(token: access_token,  dev_id: devid,msg_id: $scope.msg_id,msg: $scope.msg, (results) ->         
        $scope.happnInfo.send_msg_result = results[0].jsonObj
        $scope.send_msg_flag = false
      )

    $scope.getUserProfile = ->
      if($scope.other_user_id == undefined)
        alert "Please input Partner ID"
        return
      access_token = $scope.happnInfo.access_token
      
      if($scope.happnInfo.device == undefined)
        alert "Please Register Device."
        return
      devid = $scope.happnInfo.device.id
      if(access_token == undefined )
        alert "Please Happn Login with Facebook."
        return
      $scope.get_profile_flag = true
      Happn = $resource('/happn/get_user_profile', { format: 'json' })
      
      Happn.query(token: access_token, dev_id: devid,other_user_id: $scope.other_user_id, (results) ->         
        $scope.other_user_profile = results[0].jsonObj
        $scope.get_profile_flag = false
      )

    $scope.LikeSomebody = ->
      if($scope.partner_id == undefined)
        alert "Please input Partner ID"
        return
      access_token = $scope.happnInfo.access_token
      userid = $scope.happnInfo.user_id
      
      if($scope.happnInfo.device == undefined)
        alert "Please Register Device."
        return
      devid = $scope.happnInfo.device.id
      if(access_token == undefined || userid == undefined )
        alert "Please Happn Login with Facebook."
        return
      $scope.somebody_flag = true
      Happn = $resource('/happn/like_somebody', { format: 'json' })
      
      Happn.query(token: access_token, dev_id: devid, user_id: userid,other_user_id: $scope.partner_id, (results) ->  
        console.log results       
        $scope.somebody_msg = results[0].jsonObj
        $scope.somebody_flag = false
      )

    $scope.CharmSomebody = ->
      if($scope.partner_id == undefined)
        alert "Please input Partner ID"
        return
      access_token = $scope.happnInfo.access_token
      userid = $scope.happnInfo.user_id
      
      if($scope.happnInfo.device == undefined)
        alert "Please Register Device."
        return
      devid = $scope.happnInfo.device.id
      if(access_token == undefined || userid == undefined )
        alert "Please Happn Login with Facebook."
        return
      $scope.somebody_flag = true
      Happn = $resource('/happn/charm_somebody', { format: 'json' })
      
      Happn.query(token: access_token, dev_id: devid, user_id: userid,other_user_id: $scope.partner_id, (results) ->         
        $scope.somebody_msg = results[0].jsonObj
        $scope.somebody_flag = false
      )

    $scope.RejectSomebody = ->
      if($scope.partner_id == undefined)
        alert "Please input Partner ID"
        return
      access_token = $scope.happnInfo.access_token
      userid = $scope.happnInfo.user_id
      
      if($scope.happnInfo.device == undefined)
        alert "Please Register Device."
        return
      devid = $scope.happnInfo.device.id
      if(access_token == undefined || userid == undefined )
        alert "Please Happn Login with Facebook."
        return
      $scope.somebody_flag = true
      Happn = $resource('/happn/reject_somebody', { format: 'json' })
      
      Happn.query(token: access_token, dev_id: devid, user_id: userid,other_user_id: $scope.partner_id, (results) ->         
        $scope.somebody_msg = results[0].jsonObj
        $scope.somebody_flag = false
      )

    $scope.SetUserLocation = ->
      access_token = $scope.happnInfo.access_token
      userid = $scope.happnInfo.user_id
      
      if($scope.happnInfo.device == undefined)
        alert "Please Register Device."
        return
      devid = $scope.happnInfo.device.id

      if(access_token == undefined || userid == undefined )
        alert "Please Happn Login with Facebook."
        return

      $scope.set_user_location_flag = true
      Happn = $resource('/happn/set_location', { format: 'json' })

      console.log access_token
      console.log devid
      console.log userid
      
      Happn.query(token: access_token, dev_id: devid, user_id: userid, altitude: $scope.altitude, latitude: $scope.latitude, longitude: $scope.longitude, (results) ->         
        $scope.user_location = results[0].jsonObj
        $scope.set_user_location_flag = false
      )

    $scope.UpdateUserProfile = ->      
      access_token = $scope.happnInfo.access_token
      userid = $scope.happnInfo.user_id      
      if($scope.happnInfo.device == undefined)
        alert "Please Register Device."
        return
      devid = $scope.happnInfo.device.id
      if(access_token == undefined || userid == undefined )
        alert "Please Happn Login with Facebook."
        return
      $scope.update_user_flag = true
      Happn = $resource('/happn/update_profile', { format: 'json' })
      #Job, Workplace, School and About myself
      user_info = {}
      user_info.job       = $scope.job
      user_info.workplace = $scope.workplace
      user_info.school    = $scope.school
      user_info.about     = $scope.about
      Happn.query(token: access_token, dev_id: devid, user_id: userid,u_info: user_info, (results) ->         
        $scope.update_msg = results[0].jsonObj
        $scope.update_user_flag = false
      )

    $scope.GetUserSetting = ->      
      access_token = $scope.happnInfo.access_token
      userid = $scope.happnInfo.user_id      
      if($scope.happnInfo.device == undefined)
        alert "Please Register Device."
        return
      devid = $scope.happnInfo.device.id
      if(access_token == undefined || userid == undefined )
        alert "Please Happn Login with Facebook."
        return
      $scope.get_user_setting_flag = true
      Happn = $resource('/happn/get_user_setting', { format: 'json' })
      
      Happn.query(token: access_token, dev_id: devid, user_id: userid, (results) ->         
        console.log results
        $scope.user_setting = results[0].jsonObj
        $scope.get_user_setting_flag = false
      )
  ])
