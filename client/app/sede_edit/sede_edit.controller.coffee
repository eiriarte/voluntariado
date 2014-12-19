'use strict'

sedeEditCtrl = ($scope, $rootScope, $params, $location, sede, url, toast) ->
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
          toast.success 'Alta realizada correctamente.'
          $location.path '/sede'
        else
          toast.error '¡Oh, no! Algo ha fallado. ¿Seguro que tienes Internet? ¡Prueba a recargar la página!'
    else
      sede.modificarPersona $scope.persona, (err, persona) ->
        if not err
          toast.success 'Registro modificado correctamente.'
          $location.path '/sede'
        else
          toast.error '¡Oh, no! Algo ha fallado. ¿Seguro que tienes Internet? ¡Prueba a recargar la página!'


angular.module 'andexApp'
  .controller 'SedeEditCtrl', [
    '$scope'
    '$rootScope'
    '$routeParams'
    '$location'
    'sedeSrv'
    'url'
    'toast'
    sedeEditCtrl
  ]
