'use strict'

###*
 # @ngdoc function
 # @name turnosApp.controller:AsistenciaCtrl
 # @description
 # # AsistenciaCtrl
 # Controller of the turnosApp
###

asistenciaCtrl = ($scope, $modal, $log, asistenciasSrv, personas, toast) ->
  datos = $scope.asistencia

  # ¿Mostrar un indicador de actividad de red?
  $scope.ajax = false

  # Clases font-awesome a usar para cada indicador
  indicadores =
    ajax: 'fa-refresh fa-spin'
    si: 'fa-check'
    no: 'fa-close'
    na: 'fa-question'

  $scope.indicador = -> indicadores[$scope.ajax or datos.estado]

  # ¿Está la persona inactiva en ANDEX? (no asiste hasta nuevo aviso)
  $scope.isInactivo = ->
    'I' is personas.getEstado datos.persona, datos.anno, datos.mes, datos.dia

  # Insertar, modificar o eliminar la asistencia
  guardarNotificacion = (opcion) ->
    if opcion in ['si', 'no']
      $scope.ajax = 'ajax'
      asistenciasSrv.guardar datos, opcion, (error) ->
        $scope.ajax = false
        if not error
          toast.success 'Asistencia confirmada. ¡Nos vemos en el hospi! :)' if opcion is 'si'
          toast.success 'Ausencia notificada. ¡Gracias por avisar! :)' if opcion is 'no'
        else
          toast.error '¡Oh, no! Algo ha fallado. ¿Seguro que tienes Internet? ¡Prueba a recargar la página!'

    if opcion is 'na' and datos._id
      $scope.ajax = 'ajax'
      asistenciasSrv.eliminar datos, (error) ->
        $scope.ajax = false
        if not error
          toast.success 'Notificación eliminada (vuelve a considerarse "Falta sin avisar").'
        else
          toast.error '¡Oh, no! Algo ha fallado. ¿Seguro que tienes Internet? ¡Prueba a recargar la página!'

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

angular.module('andexApp').controller 'AsistenciaCtrl', [
  '$scope'
  '$modal'
  '$log'
  'asistenciasSrv'
  'personas'
  'toast'
  asistenciaCtrl
]
