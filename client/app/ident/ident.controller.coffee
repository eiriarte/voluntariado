'use strict'

identCtrl = ($scope, $rootScope, $window, turnos, BrowserID) ->
  # ¿No existe ese código?
  if not andex_data.identificacion? or andex_data.identificacion is 404
    return $window.location.href = '/login'

  $rootScope.seccion = 'sc-ident'
  $scope.persona = andex_data.identificacion
  turno = turnos.getTurno $scope.persona.turno
  $scope.persona.turno = turno.nombre
  $scope.loginOauth = (provider) ->
    # TODO: pantalla equivalente para sede (¿reutilizar?)
    $window.location.href = '/auth/' + provider + '?vid=' + $scope.persona.vid
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
