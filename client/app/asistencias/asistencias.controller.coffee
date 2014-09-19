'use strict'

###*
 # @ngdoc function
 # @name turnosApp.controller:AsistenciasCtrl
 # @description
 # # AsistenciasCtrl
 # Controller of the turnosApp
###

asistenciasCtrl = ($scope, $modal, $log, localStorageService, asistenciasSrv) ->
  turno = $scope.turno._id

  # Listas minimizables
  $scope.isMinimizado = ->
    minimizados = localStorageService.get('minimizados') ? {}
    return !!minimizados[turno]

  $scope.toggleMinimizado = ->
    minimizados = localStorageService.get('minimizados') ? {}
    minimizados[turno] = not minimizados[turno]
    localStorageService.set 'minimizados', minimizados

  # Diálogo para notificar ausencias / asistencias
  $scope.nuevoVoluntario = ->
    menu = $modal.open {
      templateUrl: '/nuevovoluntario.html'
      controller: 'NuevovoluntarioCtrl'
      size: 'sm',
      scope: $scope,
    }

    # Al cerrarse el diálogo…
    menu.result.then (opcion) ->
      $log.debug 'Opción elegida: ', opcion

  # Obtener la(s) lista(s) de asistencias cuando estén los datos
  $scope.anno = $scope.$parent.anno
  $scope.mes = $scope.$parent.mes
  $scope.dia = $scope.$parent.dia
  $scope.$on 'ready', ->
    $scope.asistencias = asistenciasSrv.getAsistencias $scope.anno, $scope.mes, $scope.dia, turno

angular.module('andexApp').controller 'AsistenciasCtrl', [
  '$scope',
  '$modal',
  '$log',
  'localStorageService',
  'asistenciasSrv',
  asistenciasCtrl
]