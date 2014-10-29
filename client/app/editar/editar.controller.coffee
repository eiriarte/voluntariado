'use strict'

editarCtrl = ($scope, $params, $location, $log, turnos, estados, personas) ->
  turno = turnos.getTurno $params.turno
  if not turno
    # TODO: mostrar error 404
    console.log "Con id. #{$params.turno}, getTurno devuelve ", turnos.getTurno $params.turno
  $scope.persona =
    nombre: ''
    apellidos: ''
    turno: turno._id
    estado: 'A'
  if $params.persona
    alta = false
    accion = 'Guardar cambios'
    $scope.back = $params.turno + '/vol/' + $params.persona
    # Copiar valores en $scope.persona
    persona = personas.getPersona $params.persona
    if persona
      $scope.persona._id = persona._id
      $scope.persona.nombre = persona.nombre
      $scope.persona.apellidos = persona.apellidos
      $scope.persona.turno = _.last(persona.turnos).turno
      $scope.persona.estado = _.last(persona.estados).estado
    else
      # TODO: mostrar error 404
      $log.debug "Con id. #{$params.persona}, getPersona devuelve ", persona
  else
    alta = true
    accion = 'Dar de alta'
    $scope.back = $params.turno

  # Devuelve un array con los estados posibles,
  # siendo los primeros 'A', 'I' y 'B', en ese orden
  arrayEstados = (estados) ->
    result = _.map estados, (estado, id) ->
      # 1. Dejamos los I, A, B para el final, insertamos los demás (si hay)
      return if id in ['I', 'A', 'B'] then null else { id: id, etiqueta: estado }
    # 2. Insertamos los I, A, B en el orden adecuado
    result.unshift { id: 'B', etiqueta: estados['B'] }
    result.unshift { id: 'I', etiqueta: estados['I'] }
    result.unshift { id: 'A', etiqueta: estados['A'] }
    # 3. Eliminamos los null del paso 1
    _.compact result

  $scope.form =
    accion: accion
    turnos: turnos.getTurnos()
    estados: arrayEstados estados

  $scope.guardar = ->
    # TODO: inhabilitar botón: guardando = true…; => [ fa-refresh Guardando… ]
    if alta
      $log.debug 'Estamos dando un alta…'
      personas.altaPersona $scope.persona, (error, persona) ->
        # TODO: if error…
        if not error
          $log.debug 'Alta realizada!!!'
          slugTurno = turnos.getTurno($scope.persona.turno).slug
          $location.path "/voluntariado/#{slugTurno}/vol/#{persona._id}"
          # TODO: tostada de notificación
    else
      $log.debug 'Estamos modificando…'
      personas.modificarPersona $scope.persona, (error, persona) ->
        # TODO: if error…
        if not error
          $log.debug 'Persona modificada!!!'
          slugTurno = turnos.getTurno($scope.persona.turno).slug
          $location.path "/voluntariado/#{slugTurno}/vol/#{persona._id}"

angular.module 'andexApp'
  .controller 'EditarCtrl', [
    '$scope'
    '$routeParams'
    '$location'
    '$log'
    'turnos'
    'estados'
    'personas'
    editarCtrl
  ]
