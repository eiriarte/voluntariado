'use strict'

angular.module 'andexApp'
.config ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'app/calendario/calendario.html'
      controller: 'CalendarioCtrl'
    .when '/:anno/:mes?/:dia?',
      templateUrl: 'app/calendario/calendario.html'
      controller: 'CalendarioCtrl'
