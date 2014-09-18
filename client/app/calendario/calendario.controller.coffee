'use strict'

###*
 # @ngdoc function
 # @name turnosApp.controller:CalendarioCtrl
 # @description Controlador para la vista calendario
 # # CalendarioCtrl
 # Controller of the turnosApp
###

calendarioCtrl = ($scope, $params, $timeout, fechas, asistenciasSrv, turnos) ->
  hoy = new Date()
  # Datos para el calendario
  $scope.anno = +($params.anno ? hoy.getFullYear())
  $scope.mes = +($params.mes ? hoy.getMonth() + 1)
  $scope.dia = +($params.dia)
  $scope.annoAnterior = if $scope.mes is 1 then $scope.anno - 1 else $scope.anno
  $scope.annoSiguiente = if $scope.mes is 12 then $scope.anno + 1 else $scope.anno
  $scope.mesAnterior = if $scope.mes is 1 then 12 else $scope.mes - 1
  $scope.mesSiguiente = if $scope.mes is 12 then 1 else $scope.mes + 1
  $scope.mesAnno = fechas.getMesAnno $scope.anno, $scope.mes
  $scope.calendario = fechas.getCalendario $scope.anno, $scope.mes

  # Datos para la lista de turnos
  if $scope.dia
    diaSemana = fechas.getDiaSemana $scope.anno, $scope.mes, $scope.dia
    $scope.turnos = turnos.getTurnos diaSemana

  # Devuelve la url del enlace de cada día del calendario
  $scope.getURL = (dia) ->
    anno = dia.fecha.getFullYear()
    mes = dia.fecha.getMonth() + 1
    diaMes = dia.fecha.getDate()
    '/' + anno + '/' + mes + '/' + diaMes

  # Devuelve true si ese día es el seleccionado en el calendario
  $scope.isSeleccionado = (dia) ->
    anno = dia.fecha.getFullYear()
    mes = dia.fecha.getMonth() + 1
    diaMes = dia.fecha.getDate()
    anno is $scope.anno and mes is $scope.mes and diaMes is $scope.dia

  $scope.$on 'ready', ->
    # Asistencias sincronizadas con el servidor: se pintan los colores en el calendario
    for semana in $scope.calendario
      for dia in semana when dia.asistencias isnt 'otro-mes'
        dia.asistencias = asistenciasSrv.getNiveles $scope.anno, $scope.mes, dia.delMes
    return true

  $scope.$on 'asistencia', (event, delMes) ->
    # Modificada una asistencia
    for semana in $scope.calendario
      for dia in semana when dia.asistencias isnt 'otro-mes'
        if $scope.mes is dia.fecha.getMonth() + 1 and delMes is dia.delMes
          dia.asistencias = asistenciasSrv.getNiveles $scope.anno, $scope.mes, delMes
    return true

  # Sincronizar las asistencias con el servidor
  $timeout -> asistenciasSrv.syncAsistencias $scope.anno, $scope.mes

angular.module 'andexApp'
  .controller 'CalendarioCtrl', [
    '$scope'
    '$routeParams'
    '$timeout'
    'fechas'
    'asistenciasSrv'
    'turnos'
    calendarioCtrl
  ]
