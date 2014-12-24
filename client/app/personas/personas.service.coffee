'use strict'

###*
 # @ngdoc service
 # @name turnosApp.personas
 # @description
 # # personas
 # Factory in the turnosApp.
###
personasSrv = ($rootScope, $resource, $log, fechas) ->
    # Service logic
    personasAPI = $resource '/api/personas/:_id', null, update: { method: 'PUT' }
    estadosAPI = $resource '/api/personas/:_idPersona/estados/:_idEstado'
    turnosAPI = $resource '/api/personas/:_idPersona/turnos/:_idAlta'
    personas = _.map andex_data.personas, (persona) -> new personasAPI persona
    delete andex_data.personas

    # Public API here
    {
      # Devuelve el estado de la persona ese día
      getEstado: (persona, anno, mes, dia) ->
        if angular.isString persona
          persona = _.find personas, { _id: persona }
        return _.last(persona.estados).estado if !anno or !mes or !dia
        eseDia = [ anno, mes, dia ]
        ultimoEstado = 'B' # Si aún no había entrado, devolvemos "Baja"
        _.forEach persona.estados, (estado) ->
          if not fechas.esAnterior eseDia, estado.fecha
            ultimoEstado = estado.estado
          else
            return false
        return ultimoEstado

      # Devuelve el turno de la persona ese día
      getTurno: (persona, anno, mes, dia) ->
        if angular.isString persona
          persona = _.find personas, { _id: persona }
        return _.last(persona.turnos).turno if !anno or !mes or !dia
        eseDia = [ anno, mes, dia ]
        ultimoTurno = false # Si aún no había entrado, devolvemos false
        _.forEach persona.turnos, (turno) ->
          if not fechas.esAnterior eseDia, turno.alta
            ultimoTurno = turno.turno
          else
            return false
        return ultimoTurno

      # Devuelve la fecha de alta de la persona
      # (Fecha del primer estado distinto de 'B')
      getAlta: (persona) ->
        estado = _.find persona.estados, (estado) -> estado.estado isnt 'B'
        return estado?.fecha

      # Devuelve la lista de personas que estaban de alta ese día en ese turno
      getPersonas: (turno, anno, mes, dia) ->
        getEstado = @getEstado
        getTurno = @getTurno
        _.filter personas, (persona) ->
          suEstado = getEstado persona, anno, mes, dia
          suTurno = getTurno persona, anno, mes, dia
          suTurno is turno and suEstado isnt 'B'

      # Devuelve la lista actual de personas del turno, incluyendo bajas
      getLista: (idTurno) ->
        # Si no se pasa un idTurno, devolvemos la lista completa
        return personas if not idTurno?
        getTurno = @getTurno
        _.filter personas, (persona) -> getTurno(persona) is idTurno

      getTotalActivos: ->
        getEstado = @getEstado
        getTurno = @getTurno
        totales = {}
        angular.forEach personas, (persona) ->
          suTurno = getTurno persona
          suEstado = getEstado persona
          totalesTurno = totales[suTurno] ? { total: 0, activos: 0 }
          totalesTurno.total++ if suEstado isnt 'B'
          totalesTurno.activos++ if suEstado is 'A'
          totales[suTurno] = totalesTurno
        return totales

      # Devuelve la persona con _id = idPersona
      getPersona: (idPersona) ->
        _.find personas, { _id: idPersona }

      # Devuelve nombre y apellidos de la persona 'id'
      getNombre: (id) ->
        persona = _.find personas, { _id: id }
        return persona.nombre + ' ' + persona.apellidos

      # Da de alta una nueva persona en la base de datos
      altaPersona: (persona, done) ->
        persona = new personasAPI
          nombre: persona.nombre
          apellidos: persona.apellidos
          coord: persona.coord
          turnos: [{ turno: persona.turno }]
          estados: [{ estado: persona.estado }]
        persona.$save ->
          personas.push persona
          $rootScope.$broadcast 'ready'
          done null, persona
        , (httpResponse) ->
          $log.error 'Error HTTP: ', httpResponse
          done httpResponse

      # Modifica una persona en la base de datos
      modificarPersona: (datos, done) ->
        persona = @getPersona datos._id
        persona.nombre = datos.nombre
        persona.apellidos = datos.apellidos
        persona.coord = datos.coord
        persona.turnos.push turno: datos.turno
        persona.estados.push estado: datos.estado
        persona.$update { _id: persona._id }, ->
          done null, persona
        , (httpResponse) ->
          $log.error 'Error HTTP: ', httpResponse
          done httpResponse

      # Registra un nuevo estado de la persona (Activo, Baja, Inactivo…)
      nuevoEstado: (id, estado, fecha, done) ->
        if angular.isFunction fecha
          done = fecha
          fecha = null
        persona = _.find personas, { _id: id }
        if persona?
          datos = { estado: estado }
          datos.fecha = fecha if fecha?
          estadosAPI.save { _idPersona: id }, datos, (data) ->
            persona.estados.push data
            $rootScope.$broadcast 'ready'
            done?()
    }


angular.module 'andexApp'
  .factory 'personas', [
    '$rootScope'
    '$resource'
    '$log'
    'fechas'
    personasSrv
  ]
