'use strict'

angular
  .module 'andexApp'
  .controller 'LoginCtrl', ($scope, $rootScope, $window, BrowserID) ->
    $rootScope.seccion = 'sc-ident'
    $scope.loginOauth = (provider) ->
      $window.location.href = '/auth/' + provider
    $scope.loginBrowserID = ->
      BrowserID.request()
