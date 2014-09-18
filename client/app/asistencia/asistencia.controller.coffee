'use strict'

###*
 # @ngdoc function
 # @name turnosApp.controller:AsistenciaCtrl
 # @description
 # # AsistenciaCtrl
 # Controller of the turnosApp
###

asistenciaCtrl = ($scope, $modal, $log, asistenciasSrv) ->
  # Insertar, modificar o eliminar la asistencia
  guardarNotificacion = (opcion) ->
    asistenciasSrv.guardar($scope.asistencia, opcion) if opcion in ['si', 'no']
    asistenciasSrv.eliminar($scope.asistencia) if opcion is 'na' and $scope.asistencia._id

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
      # Baja, Inactivo
      # persona = personas.getPersona(id)
      # persona.nuevoEstado(estado) -> (create)
      $log.debug 'Opción elegida: ' + opcion
      if opcion in ['si', 'no', 'na']
        guardarNotificacion opcion

angular.module('andexApp').controller 'AsistenciaCtrl', [
  '$scope',
  '$modal',
  '$log',
  'asistenciasSrv',
  asistenciaCtrl
]
