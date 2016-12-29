aggregate_dating = angular.module('aggregate_dating',[
  	'templates',
  	'ngRoute',
    'ngResource',
  	'controllers',
  	'facebook'
])

aggregate_dating.config([ '$routeProvider',
  	($routeProvider)->
    	$routeProvider
      	.when('/',
          templateUrl: "index.html"
          controller: 'CMBController'
        )

   
])

aggregate_dating.config([ '$facebookProvider',
 	($facebookProvider)->
      	$facebookProvider
        .init({
            appId: '349609268750448'
        })
])

aggregate_dating.config(['$qProvider', 
  ($qProvider)->
    $qProvider.errorOnUnhandledRejections(false);
])


cmbInfo = []

controllers = angular.module('controllers',[])
controllers.controller("CMBController", [ '$scope', '$routeParams', '$location', '$facebook', '$http', '$resource'
  ($scope,$routeParams,$location,$facebook,$http,$resource)->
    
    $scope.login_flag = false
    $scope.loginFacebook = ->           
      $scope.login_flag = true
      $facebook.login(scope: 'email').then ((response) ->
        authtoken = response.authResponse.accessToken
        console.log 'FB Login Success', authtoken
        $scope.fbToken = authtoken
        $scope.loginCMB(authtoken)
    ), (response) ->
        console.log 'FB Login Error', response
 
	
    $scope.loginCMB = (authtoken) ->
      console.log 'LOGIN CMB'     
      Cmb = $resource('/cmb', { format: 'json' })
      Cmb.query(fbToken: authtoken , (results) -> 
        $scope.cmbInfo = results
        $scope.sessionid = results[0].sessionid
        $scope.userid = results[0].jsonObj.id
        $scope.user_gender = results[0].jsonObj.gender
        $scope.user_name = results[0].jsonObj.full_name
        $scope.user_email = results[0].jsonObj.user__email        
        $scope.user_criteria_gender = results[0].jsonObj.criteria__gender        
        $scope.user_birthday = new Date(results[0].jsonObj.birthday)
        $scope.login_flag = false
      )
    $scope.setMyProfile = ->
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
      $scope.user = {}
      $scope.user.name = $scope.user_name
      $scope.user.id = $scope.userid
      $scope.user.gender = $scope.user_gender
      $scope.user.birthday = $scope.user_birthday
      $scope.user.email = $scope.user_email
      $scope.user.criteria_gender = $scope.user_criteria_gender 

      Cmb = $resource('/cmb/set_profile', { format: 'json' })
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, user: $scope.user , (results) -> 
        $scope.cmbInfo = results
        $scope.sessionid = results[0].sessionid
        $scope.userid = results[0].jsonObj.id
        $scope.user_gender = results[0].jsonObj.gender
        $scope.user_name = results[0].jsonObj.full_name
        $scope.user_email = results[0].jsonObj.user__email        
        $scope.user_criteria_gender = results[0].jsonObj.criteria__gender        
        $scope.user_birthday = new Date(results[0].jsonObj.birthday)
        console.log 'data OK'   
      )
    $scope.setBagels = ->
      if(not $scope.fbToken?)
        alert "Please Click 'Login with Facebook'."
        return     
      Cmb = $resource('/cmb/get_bagels', { format: 'json' })
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, (results) -> 
        $scope.BagelsInfo = results
        $scope.BagelInfo = {}
        $scope.BagelInfo.hex_id = results[0].jsonObj.current_token
        $scope.BagelInfo.cursor_after = results[0].jsonObj.cursor_after
        $scope.BagelInfo.cursor_before = results[0].jsonObj.cursor_before
        $scope.BagelInfo.more_after = results[0].jsonObj.more_after
        $scope.BagelInfo.more_before = results[0].jsonObj.more_before
        console.log 'Bagles OK'   
      )
    $scope.getBagelsHistory = ->
      if(not $scope.fbToken?)
        alert "Please Click 'Login with Facebook'."
        return    
         
      if(not $scope.BagelInfo.hex_id?)
        alert "Please Click 'Set Bagels'."
        return    
      
      Cmb = $resource('/cmb/get_bagels_history', { format: 'json' })
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, bagel: $scope.BagelInfo, (results) -> 
        $scope.BagelsList = results       
        console.log 'Bagles History OK'   
      )
    $scope.getResources = ->
      Cmb = $resource('/cmb/get_resources', { format: 'json' })
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, (results) -> 
        $scope.ResourceInfo = results
        console.log 'ResourceOk'
      )

    $scope.photolabs = ->
      if(not $scope.fbToken?)
        alert "Please Click 'Login with Facebook'."
        return
      Cmb = $resource('/cmb/get_photolabs', { format: 'json' })
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, (results) -> 
        $scope.PhotoLabs = results
        console.log 'get_photoLabs'
      )

    $scope.giveTake = ->
      if(not $scope.fbToken?)
        alert "Please Click 'Login with Facebook'."
        return
      $scope.girl_id = '2244848'
      Cmb = $resource('/cmb/give_take', { format: 'json' })      
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, customer_id: $scope.girl_id, (results) -> 
        $scope.GiveTaskResult = results
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
      $scope.Purchase = {}
      $scope.Purchase.item_name = $scope.item_name
      $scope.Purchase.item_count = $scope.item_count
      $scope.Purchase.expected_price = $scope.expected_price
      $scope.Purchase.give_ten_id = $scope.give_ten_id
      
      Cmb = $resource('/cmb/purchase', { format: 'json' })      
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, purchase: $scope.Purchase, (results) -> 
        $scope.GiveTaskResult = results
        console.log 'PurchaseOK'
      )

    $scope.report = ->
      if(not $scope.fbToken?)
        alert "Please Click 'Login with Facebook'."
        return
      Cmb = $resource('/cmb/report', { format: 'json' })      
      $scope.report_num = "4"
      Cmb.query(fbToken: $scope.fbToken, sessionid: $scope.sessionid, (results) -> 
        $scope.ReportResult = results
        console.log 'Report'
      )

])

