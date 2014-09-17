'use strict'

###*
 # @ngdoc function
 # @name turnosApp.controller:AsistenciaCtrl
 # @description
 # # AsistenciaCtrl
 # Controller of the turnosApp
###

asistenciaCtrl = ($scope, $modal) ->
  # Diálogo para notificar ausencias / asistencias
  $scope.modalNotificar = ->
    menu = $modal.open {
      templateUrl: '/notificar.html'
      controller: 'NotificarCtrl'
      size: 'sm',
      scope: $scope,
      resolve: {
        asistencia: -> $scope.asistencia
      }
    }

    # Al cerrarse el diálogo…
    menu.result.then (opcion) ->
      console.log 'Opción elegida: ' + opcion

angular.module('andexApp').controller 'AsistenciaCtrl', [
  '$scope',
  '$modal',
  asistenciaCtrl
]
