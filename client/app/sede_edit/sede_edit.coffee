'use strict'

angular.module 'andexApp'
.config ($routeProvider) ->
  $routeProvider.when '/sede/alta',
    templateUrl: 'app/sede_edit/sede_edit.html'
    controller: 'SedeEditCtrl'
  $routeProvider.when '/sede/usr/:persona/editar',
    templateUrl: 'app/sede_edit/sede_edit.html'
    controller: 'SedeEditCtrl'
