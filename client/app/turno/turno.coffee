'use strict'

angular.module 'andexApp'
.config ($routeProvider) ->
  $routeProvider.when '/voluntariado/:turno',
    templateUrl: 'app/turno/turno.html'
    controller: 'TurnoCtrl'
    authenticate: true
