'use strict'

cambiarGrupoCtrl = ($log, $scope, $modalInstance, turnos, personas) ->
  turnoPersona = personas.getTurno $scope.asistencia.persona
  isActual = (idTurno) -> idTurno is turnoPersona

  $scope.listaTurnos = turnos.getTurnos()

  $scope.isActual = isActual

  $scope.seleccion = (idTurno) ->
    $log.debug 'Turno seleccionado: ' + idTurno
    $modalInstance.close idTurno if not isActual idTurno

  # Click en Cancelar
  $scope.cancelar = ->
    $modalInstance.dismiss 'Cancelar'

angular.module 'andexApp'
  .controller 'CambiarGrupoCtrl', [
    '$log'
    '$scope'
    '$modalInstance'
    'turnos'
    'personas'
    cambiarGrupoCtrl
  ]
