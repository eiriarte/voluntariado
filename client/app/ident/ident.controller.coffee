'use strict'

identCtrl = ($scope, $rootScope, $window, turnos) ->
    $rootScope.seccion = 'sc-ident'
    $scope.persona = andex_data.identificacion
    turno = turnos.getTurno $scope.persona.turno
    $scope.persona.turno = turno.nombre
    $scope.loginOauth = (provider) ->
      $window.location.href = '/auth/' + provider + '?codigo=' + $scope.persona.codigo

angular.module 'andexApp'
  .controller 'IdentCtrl', [
    '$scope'
    '$rootScope'
    '$window'
    'turnos'
    identCtrl
  ]
