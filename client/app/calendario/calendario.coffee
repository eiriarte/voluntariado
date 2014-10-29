'use strict'

angular.module 'andexApp'
.config ($routeProvider) ->
  $routeProvider
    .when '/asistencias',
      templateUrl: 'app/calendario/calendario.html'
      controller: 'CalendarioCtrl'
    .when '/asistencias/:anno/:mes?/:dia?',
      templateUrl: 'app/calendario/calendario.html'
      controller: 'CalendarioCtrl'
