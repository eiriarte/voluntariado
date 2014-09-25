'use strict'

configFn = ($routeProvider, $locationProvider, localStorageServiceProvider) ->
  $routeProvider
  .otherwise
    redirectTo: '/'

  $locationProvider.html5Mode true

  localStorageServiceProvider.setPrefix 'andex'

angular.module 'andexApp', [
  'ngResource',
  'ngAnimate',
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
