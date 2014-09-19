'use strict'

altaCtrl = ($scope, $modalInstance) ->
  $scope.persona = {
    nombre: ''
    apellidos: ''
  }

  $scope.altaVoluntario = ->
    $modalInstance.close $scope.persona

  $scope.cancelar = ->
    $modalInstance.dismiss 'Cancelar'

angular.module('andexApp').controller 'NuevovoluntarioCtrl', [
  '$scope',
  '$modalInstance',
  altaCtrl
]
