'use strict'

configFn = ($routeProvider, $locationProvider, $httpProvider, localStorageServiceProvider) ->
  $routeProvider
  .otherwise
    redirectTo: '/asistencias'

  $locationProvider.html5Mode true

  $httpProvider.interceptors.push 'authInterceptor'
  localStorageServiceProvider.setPrefix 'andex'

angular.module 'andexApp', [
  'ngCookies',
  'ngResource',
  'ngAnimate',
  'ngSanitize',
  'ngRoute',
  'ui.bootstrap',
  'LocalStorageModule'
]
.config [
  '$routeProvider',
  '$locationProvider',
  '$httpProvider',
  'localStorageServiceProvider',
  configFn
]
# TODO: usar la sintaxis [ '$rootScope', '$q', … etc, nombreFunción ]
.factory 'authInterceptor', ($rootScope, $q, $cookieStore, $location) ->
  # Add authorization token to headers
  request: (config) ->
    config.headers = config.headers or {}
    config.headers.Authorization = 'Bearer ' + $cookieStore.get 'token' if $cookieStore.get 'token'
    config

  # Intercept 401s and redirect you to login
  responseError: (response) ->
    if response.status is 401
      $location.path '/login'
      # remove any stale tokens
      $cookieStore.remove 'token'

    $q.reject response
.value 'estados',
  'A': 'En activo',
  'I': 'No asiste hasta nuevo aviso',
  'B': 'Baja'
.run ($rootScope, $location, Auth, BrowserID) ->
  # Redirect to login if route requires auth and you're not logged in
  $rootScope.$on '$routeChangeStart', (event, next) ->
    Auth.isLoggedInAsync (loggedIn) ->
      # TODO: Añadir la propiedad authenticate a las rutas no públicas
      $location.path "/login" if next.authenticate and not loggedIn
      if not loggedIn or Auth.getCurrentUser().provider is 'browserid'
        BrowserID.watch Auth.getCurrentUser().email or null
