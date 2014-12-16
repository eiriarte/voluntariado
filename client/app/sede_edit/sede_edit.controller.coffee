'use strict'

sedeEditCtrl = ($scope, $rootScope, $params, $location, sede, url) ->
  $rootScope.seccion = 'sc-sede'
  if $params.persona
    alta = false
    accion = 'Guardar cambios'
    $scope.persona = angular.copy sede.getPersona($params.persona)
    $scope.persona.identVisible = false
    $scope.persona.identBase = url '/sede/id/'
  else
    alta = true
    accion = 'Dar de alta'
    $scope.persona =
      nombre: ''
      apellidos: ''

  $scope.form =
    accion: accion

  $scope.guardar = ->
    if alta
      # TODO: ¡Ya existe una persona con ese mismo nombre!
      sede.altaPersona $scope.persona, (err, persona) ->
        if not err
          $location.path '/sede'
    else
      sede.modificarPersona $scope.persona, (err, persona) ->
        if not err
          $location.path '/sede'


angular.module 'andexApp'
  .controller 'SedeEditCtrl', [
    '$scope'
    '$rootScope'
    '$routeParams'
    '$location'
    'sedeSrv'
    'url'
    sedeEditCtrl
  ]
