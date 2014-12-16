'use strict'

identCtrl = ($scope, $rootScope, $window, turnos, BrowserID) ->
  # ¿No existe ese código?
  if not andex_data.identificacion? or andex_data.identificacion is 404
    return $window.location.href = '/login'

  $rootScope.seccion = 'sc-ident'
  $scope.persona = andex_data.identificacion
  if $scope.persona.turno?
    turno = turnos.getTurno $scope.persona.turno
    $scope.persona.turno = turno.nombre
  else
    $scope.persona.turno = '(personal de la sede)'

  $scope.loginOauth = (provider) ->
    if $scope.persona.vid?
      $window.location.href = '/auth/' + provider + '?vid=' + $scope.persona.vid
    else
      $window.location.href = '/auth/' + provider + '?sid=' + $scope.persona.sid

  $scope.loginBrowserID = ->
    BrowserID.request()

angular.module 'andexApp'
  .controller 'IdentCtrl', [
    '$scope'
    '$rootScope'
    '$window'
    'turnos'
    'BrowserID'
    identCtrl
  ]
