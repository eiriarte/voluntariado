'use strict'

###*
 # @ngdoc function
 # @name turnosApp.controller:NotificarCtrl
 # @description
 # # NotificarCtrl
 # Controller of the turnosApp
###

notificarCtrl = ($scope, $modalInstance, auth, fechas, asistencia) ->
  usuarioActual = auth.getUsuarioActual()
  $scope.asistencia = asistencia
  $scope.turno =
    diaMesAnno: fechas.getFechaLegible $scope.$parent.anno, $scope.$parent.mes, $scope.dia
    diaSemana: fechas.getDiaSemCorto $scope.$parent.anno, $scope.$parent.mes, $scope.dia
    entrada: $scope.$parent.turno.entrada
    salida: $scope.$parent.turno.salida

  # No se podrán comunicar ausencias/asistencias "retroactivamente"
  entonces = [ $scope.anno, $scope.mes, $scope.dia ]
  hoy = new Date andex_data.hoy

  # ¿Puede el usuario actual notificar esta ausencia/asistencia?
  $scope.puedeNotificar = ->
    mismoTurno = $scope.asistencia.turno is usuarioActual.getIdTurno()
    demasiadoTarde = fechas.esAnterior entonces, hoy
    # Puede, si es del mismo turno, y no es "retroactivamente", o si es de la sede
    (mismoTurno or usuarioActual.esSede()) and not demasiadoTarde

  # ¿Puede el usuario actual eliminar esta notificación?
  $scope.puedeDeshacer = ->
    idPersona = $scope.asistencia.persona
    mismoTurno = $scope.asistencia.turno is usuarioActual.getIdTurno()
    tienePermiso = mismoTurno and usuarioActual.esCoordinador()
    tienePermiso = tienePermiso or usuarioActual.persona is idPersona
    # Puede, si es propia, si es un coordinador del turno,
    # o es de la sede, y hay algo que eliminar
    (usuarioActual.esSede() or tienePermiso) and $scope.asistencia.estado isnt 'na'

  # Click en una de las opciones
  $scope.seleccionarOpcion = (opcion) ->
    $modalInstance.close opcion

  # Click en Cancelar
  $scope.cancelar = ->
    $modalInstance.dismiss 'Cancelar'

angular.module('andexApp').controller 'NotificarCtrl', [
  '$scope'
  '$modalInstance'
  'auth'
  'fechas'
  'asistencia'
  notificarCtrl
]
