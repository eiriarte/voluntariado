'use strict'

###*
 # @ngdoc function
 # @name turnosApp.controller:AsistenciaCtrl
 # @description
 # # AsistenciaCtrl
 # Controller of the turnosApp
###

asistenciaCtrl = ($scope, $modal, $log, asistenciasSrv, personas) ->
  datos = $scope.asistencia

  # ¿Mostrar un indicador de actividad de red?
  $scope.ajax = false

  # ¿Está la persona inactiva en ANDEX? (no asiste hasta nuevo aviso)
  $scope.isInactivo = ->
    'I' is personas.getEstado datos.persona, datos.anno, datos.mes, datos.dia

  # Insertar, modificar o eliminar la asistencia
  guardarNotificacion = (opcion) ->
    if opcion in ['si', 'no']
      $scope.ajax = 'ajax'
      asistenciasSrv.guardar datos, opcion, -> $scope.ajax = false
    if opcion is 'na' and datos._id
      $scope.ajax = 'ajax'
      asistenciasSrv.eliminar datos, -> $scope.ajax = false

  # Diálogo para notificar ausencias / asistencias
  $scope.modalNotificar = ->
    menu = $modal.open
      templateUrl: '/notificar.html'
      controller: 'NotificarCtrl'
      size: 'sm'
      scope: $scope
      resolve: {
        asistencia: -> datos
      }

    # Al cerrarse el diálogo…
    menu.result.then (opcion) ->
      $log.debug 'Opción elegida: ' + opcion
      if opcion in ['si', 'no', 'na']
        guardarNotificacion opcion
      else if opcion in ['A', 'B', 'I']
        $scope.ajax = 'ajax'
        personas.nuevoEstado datos.persona, opcion, -> $scope.ajax = false

angular.module('andexApp').controller 'AsistenciaCtrl', [
  '$scope'
  '$modal'
  '$log'
  'asistenciasSrv'
  'personas'
  asistenciaCtrl
]
