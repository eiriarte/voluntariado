'use strict'

angular.module 'andexApp'
.config ($routeProvider) ->
  $routeProvider.when '/login',
    templateUrl: 'app/login/login.html'
    controller: 'LoginCtrl'
