'use strict'

loginCtrl = ($scope, $rootScope, $window, $location, BrowserID, toast) ->
  $rootScope.seccion = 'sc-ident'

  # Venimos de un fallo en oAuth?
  if $location.search().error in ['fb', 'go']
    toast.error 'Parece que ha habido algún problema con la identificación :('

  $scope.loginOauth = (provider) ->
    $window.location.href = '/auth/' + provider

  $scope.loginBrowserID = ->
    BrowserID.request()

angular
  .module 'andexApp'
  .controller 'LoginCtrl', [
    '$scope'
    '$rootScope'
    '$window'
    '$location'
    'BrowserID'
    'toast'
    loginCtrl
  ]
