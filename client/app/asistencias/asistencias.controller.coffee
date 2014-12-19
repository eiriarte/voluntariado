'use strict'

###*
 # @ngdoc function
 # @name turnosApp.controller:AsistenciasCtrl
 # @description
 # # AsistenciasCtrl
 # Controller of the turnosApp
###

asistenciasCtrl = ($scope, $modal, $log, localStorageService, asistenciasSrv, personas, Auth) ->
  turno = $scope.turno._id
  $scope.ready = false

  # Autenticación
  $scope.loggedIn = Auth.isLoggedIn

  # Listas minimizables
  $scope.isMinimizado = ->
    minimizados = localStorageService.get('minimizados') ? {}
    return !!minimizados[turno]

  $scope.toggleMinimizado = ->
    minimizados = localStorageService.get('minimizados') ? {}
    minimizados[turno] = not minimizados[turno]
    localStorageService.set 'minimizados', minimizados

  # Orden por Nombre+Apellidos
  $scope.orden = (asistencia) -> personas.getNombre asistencia.persona

  # Calcula el total de asistencias, ausencias y por confirmar
  calcularTotales = (asistencias) ->
    totales = si: 0, no: 0, na: 0
    angular.forEach asistencias, (asistencia) ->
      totales[asistencia.estado]++
    return totales

  # Obtener la(s) lista(s) de asistencias cuando estén los datos
  $scope.anno = $scope.$parent.anno
  $scope.mes = $scope.$parent.mes
  $scope.dia = $scope.$parent.dia
  $scope.$on 'ready', ->
    $scope.ready = true
    $scope.asistencias = asistenciasSrv.getAsistencias $scope.anno, $scope.mes, $scope.dia, turno
    $scope.totales = calcularTotales $scope.asistencias

angular.module('andexApp').controller 'AsistenciasCtrl', [
  '$scope'
  '$modal'
  '$log'
  'localStorageService'
  'asistenciasSrv'
  'personas'
  'Auth'
  asistenciasCtrl
]
