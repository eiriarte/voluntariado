'use strict'

###*
 # @ngdoc function
 # @name turnosApp.controller:NotificarCtrl
 # @description
 # # NotificarCtrl
 # Controller of the turnosApp
###

notificarCtrl = ($scope, $modalInstance, fechas, asistencia) ->
  $scope.asistencia = asistencia
  $scope.turno =
    diaMesAnno: fechas.getFechaLegible $scope.$parent.anno, $scope.$parent.mes, $scope.dia
    diaSemana: fechas.getDiaSemCorto $scope.$parent.anno, $scope.$parent.mes, $scope.dia
    entrada: $scope.$parent.turno.entrada
    salida: $scope.$parent.turno.salida

  # (des)plegar Otras Opciones
  $scope.desplegado = false
  $scope.toggleDesplegado = -> $scope.desplegado = not $scope.desplegado

  # Click en una de las opciones
  $scope.seleccionarOpcion = (opcion) ->
    $modalInstance.close opcion

  # Click en Cancelar
  $scope.cancelar = ->
    $modalInstance.dismiss 'Cancelar'

angular.module('andexApp').controller 'NotificarCtrl', [
  '$scope',
  '$modalInstance',
  'fechas',
  'asistencia',
  notificarCtrl
]
