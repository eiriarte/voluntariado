'use strict'

configFn = ($routeProvider, $locationProvider, localStorageServiceProvider) ->
  $routeProvider
  .otherwise
    redirectTo: '/'

  $locationProvider.html5Mode true

  localStorageServiceProvider.setPrefix 'andex'

angular.module 'andexApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'ui.bootstrap',
  'LocalStorageModule'
]
.config [
  '$routeProvider',
  '$locationProvider',
  'localStorageServiceProvider',
  configFn
]
