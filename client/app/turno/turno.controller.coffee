'use strict'

turnoCtrl = ($scope, $rootScope, $params, turnos, personas, fechas, asistencias) ->
  $rootScope.seccion = 'sc-voluntariado'
  $scope.verEstados = '!B' # Bajas ocultas por defecto
  $scope.cargandoAsistencias = true

  turnos = turnos.getTurnos()
  $scope.turno = angular.copy _.find(turnos, { slug: $params.turno })

  totalBajas = 0

  $scope.turno.personas = personas.getLista $scope.turno._id
  angular.forEach $scope.turno.personas, (persona) ->
    persona.estado = _.last(persona.estados).estado
    if persona.estado is 'B'
      totalBajas += 1

  $scope.turno.bajas = totalBajas

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
    'turnos'
    'personas'
    'fechas'
    'asistenciasSrv'
    turnoCtrl
  ]
