'use strict'

personaCtrl = ($scope, $params, asistencias, personas, turnos, estados) ->
  persona = personas.getPersona $params.persona
  turno = _.last(persona.turnos).turno
  turno = turnos.getTurno turno
  if turno.slug isnt $params.turno
    # TODO: redireccionar a /voluntariado/#{turno.slug}/vol/#{persona._id}
    console.log 'No es su turno. Su turno es: ' + turno.slug

  estado = _.last(persona.estados).estado

  $scope.persona =
    turno:
      slug: turno.slug
      nombre: turno.nombre
    ficha:
      id: persona._id
      nombre: persona.nombre + ' ' + persona.apellidos
      estado: estados[estado]

  asistencias.getAsistenciasPersona 2, persona, turno, (datos) ->
    $scope.persona.historial = datos
    console.log datos

angular.module 'andexApp'
  .controller 'PersonaCtrl', [
    '$scope'
    '$routeParams'
    'asistenciasSrv'
    'personas'
    'turnos'
    'estados'
    personaCtrl
  ]
