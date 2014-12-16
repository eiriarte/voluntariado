'use strict'

personaCtrl = ($scope, $rootScope, $params, $location, Auth, asistencias, personas, turnos, estados, url) ->
  $rootScope.seccion = 'sc-voluntariado'
  persona = personas.getPersona $params.persona
  turno = _.last(persona.turnos).turno
  turno = turnos.getTurno turno
  if turno.slug isnt $params.turno
    # TODO: redireccionar a /voluntariado/#{turno.slug}/vol/#{persona._id}
    console.log 'No es su turno. Su turno es: ' + turno.slug

  # Estado actual de la persona
  estado = _.last(persona.estados).estado

  $scope.persona =
    turno:
      slug: turno.slug
      nombre: turno.nombre
    ficha:
      id: persona._id
      nombre: persona.nombre + ' ' + persona.apellidos
      estado: estados[estado]
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

  asistencias.getAsistenciasPersona 2, persona, turno, (datos) ->
    $scope.persona.historial = datos
    console.log datos

angular.module 'andexApp'
  .controller 'PersonaCtrl', [
    '$scope'
    '$rootScope'
    '$routeParams'
    '$location'
    'Auth'
    'asistenciasSrv'
    'personas'
    'turnos'
    'estados'
    'url'
    personaCtrl
  ]
