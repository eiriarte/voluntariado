'use strict'

###*
 # @ngdoc function
 # @name turnosApp.controller:AsistenciasCtrl
 # @description
 # # AsistenciasCtrl
 # Controller of the turnosApp
###

asistenciasCtrl = ($scope, asistenciasSrv) ->
    # Listas minimizables
    $scope.minimizado = false
    $scope.toggleMinimizado = -> $scope.minimizado = not $scope.minimizado

    # Obtener la(s) lista(s) de asistencias cuando estén los datos
    $scope.anno = $scope.$parent.anno
    $scope.mes = $scope.$parent.mes
    $scope.dia = $scope.$parent.dia
    turno = $scope.turno._id
    $scope.$on 'ready', ->
      $scope.asistencias = asistenciasSrv.getAsistencias $scope.anno, $scope.mes, $scope.dia, turno

angular.module('andexApp').controller 'AsistenciasCtrl', [
  '$scope',
  'asistenciasSrv',
  asistenciasCtrl
]
