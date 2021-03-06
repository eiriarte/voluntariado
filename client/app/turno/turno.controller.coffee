'use strict'

turnoCtrl = ($scope, $rootScope, $params, Auth, turnos, personas, fechas, asistencias, toast) ->
  $rootScope.seccion = 'sc-voluntariado'
  $scope.verEstados = '!B' # Bajas ocultas por defecto
  $scope.cargandoAsistencias = true

  turnos = turnos.getTurnos()
  $scope.turno = angular.copy _.find(turnos, { slug: $params.turno })

  # Grupo no encontrado
  if not $scope.turno?
    $scope.turno = { nombre: '', bajas: 0 }
    $scope.cargandoAsistencias = false
    toast.error 'Oops! ¡Aquí no hay nada! Parece que has seguido una dirección errónea.', 60000
    return false

  totalBajas = 0

  $scope.turno.personas = personas.getLista $scope.turno._id
  angular.forEach $scope.turno.personas, (persona) ->
    persona.estado = _.last(persona.estados).estado
    if persona.estado is 'B'
      totalBajas += 1

  $scope.turno.bajas = totalBajas

  # ¿Puede añadir una persona al grupo?
  $scope.puedeDarAlta = ->
    mismoTurno = $scope.turno._id is Auth.getIdTurno()
    coordDelTurno = mismoTurno and Auth.esCoordinador()
    # Puede, si es coordinador de ese turno, o es usuario de la sede
    Auth.esSede() or coordDelTurno

  # Obtenemos el array de fechas, sin asistencias
  $scope.turno.asistencias = fechas.getUltimosMeses 2, $scope.turno.dia
  # Rellenamos el array con las asistencias de cada fecha de este turno
  asistencias.getUltimosMeses $scope.turno.asistencias, $scope.turno._id, ->
    $scope.cargandoAsistencias = false

angular.module 'andexApp'
  .controller 'TurnoCtrl', [
    '$scope'
    '$rootScope'
    '$routeParams'
    'Auth'
    'turnos'
    'personas'
    'fechas'
    'asistenciasSrv'
    'toast'
    turnoCtrl
  ]
