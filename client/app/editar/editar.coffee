'use strict'

angular.module 'andexApp'
.config ($routeProvider) ->
  $routeProvider.when '/voluntariado/:turno/alta',
    templateUrl: 'app/editar/editar.html'
    controller: 'EditarCtrl'
    authenticate: true
  $routeProvider.when '/voluntariado/:turno/vol/:persona/editar',
    templateUrl: 'app/editar/editar.html'
    controller: 'EditarCtrl'
    authenticate: true
