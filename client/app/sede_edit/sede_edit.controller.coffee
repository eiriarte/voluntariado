'use strict'

sedeEditCtrl = ($scope, $rootScope, $params, $location, sede, url, toast) ->
  $rootScope.seccion = 'sc-sede'
  if $params.persona
    alta = false
    accion = 'Guardar cambios'
    $scope.persona = angular.copy sede.getPersona($params.persona)

    # Persona no encontrada
    if not $scope.persona?
      $scope.form = { accion: '' }
      toast.error 'Oops! ¡Aquí no hay nada! Parece que has seguido una dirección errónea.', 60000
      return false

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
    guardando: false

  $scope.guardar = ->
    $scope.form.guardando = true
    $scope.form.accion = 'Guardando…'
    if alta
      # TODO: ¡Ya existe una persona con ese mismo nombre!
      sede.altaPersona $scope.persona, (err, persona) ->
        $scope.form.guardando = false
        $scope.form.accion = 'Dar de alta'
        if not err
          toast.success 'Alta realizada correctamente.'
          $location.path '/sede'
        else
          toast.error '¡Oh, no! Algo ha fallado. ¿Seguro que tienes Internet? ¡Prueba a recargar la página!'
    else
      sede.modificarPersona $scope.persona, (err, persona) ->
        $scope.form.guardando = false
        $scope.form.accion = 'Guardar cambios'
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
