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
  estado = personas.getEstado datos.persona, datos.anno, datos.mes, datos.dia
  $scope.inactivo = estado is 'I'

  # Insertar, modificar o eliminar la asistencia
  guardarNotificacion = (opcion) ->
    asistenciasSrv.guardar(datos, opcion) if opcion in ['si', 'no']
    asistenciasSrv.eliminar(datos) if opcion is 'na' and datos._id

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
        personas.nuevoEstado(datos.persona, opcion)

angular.module('andexApp').controller 'AsistenciaCtrl', [
  '$scope'
  '$modal'
  '$log'
  'asistenciasSrv'
  'personas'
  asistenciaCtrl
]
