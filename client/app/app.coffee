'use strict'

angular.module 'andexApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute'
]
.config ($routeProvider, $locationProvider) ->
  $routeProvider
  .otherwise
    redirectTo: '/'

  $locationProvider.html5Mode true
