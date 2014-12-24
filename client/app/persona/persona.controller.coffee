'use strict'

personaCtrl = ($scope, $rootScope, $params, $location, $log, Auth, asistencias,
                personas, turnos, estados, url, toast, fechas) ->
  $rootScope.seccion = 'sc-voluntariado'
  persona = personas.getPersona $params.persona

  # Persona no encontrada
  if not persona?
    toast.error 'Oops! ¡Aquí no hay nada! Parece que has seguido una
      dirección errónea.', 60000
    return $location.path "/voluntariado/#{$params.turno}"

  turno = _.last(persona.turnos).turno
  turno = turnos.getTurno turno

  # Turno incorrecto
  if turno.slug isnt $params.turno
    console.log 'No es su turno. Su turno es: ' + turno.slug
    toast.warning 'La dirección que has seguido ya no es correcta.
      Te redireccionamos a la dirección en el grupo correcto.'
    return $location.path "/voluntariado/#{turno.slug}/vol/#{persona._id}"

  # Estado actual de la persona
  estado = _.last(persona.estados).estado

  # Fecha de alta
  alta = personas.getAlta persona
  if fechas.esAnterior alta, [ 2015, 1, 1 ]
    alta = 'Anterior a 2015'
  else
    alta = fechas.getFechaLegible alta

  $scope.persona =
    turno:
      slug: turno.slug
      nombre: turno.nombre
    ficha:
      id: persona._id
      nombre: persona.nombre + ' ' + persona.apellidos
      estado: estados[estado]
      alta: alta
      coord: persona.coord
      identificacion: persona.identificacion
      identBase: url '/id/'
      identVisible: false

  # ¿Puede el usuario actual editar la ficha de persona?
  $scope.puedeEditar = ->
    mismoTurno = turno._id is Auth.getIdTurno()
    coordDelTurno = mismoTurno and Auth.esCoordinador()
    # Puede, si es la propia persona, su coordinador, o usuario de la sede
    Auth.persona() is persona._id or coordDelTurno or Auth.esSede()

  asistencias.getAsistenciasPersona 2, persona, (datos) ->
    $scope.persona.historial = datos
    $log.debug 'getAsistenciasPersona::: ', datos

angular.module 'andexApp'
  .controller 'PersonaCtrl', [
    '$scope'
    '$rootScope'
    '$routeParams'
    '$location'
    '$log'
    'Auth'
    'asistenciasSrv'
    'personas'
    'turnos'
    'estados'
    'url'
    'toast'
    'fechas'
    personaCtrl
  ]
