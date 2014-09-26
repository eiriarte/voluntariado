'use strict'

###*
 # @ngdoc service
 # @name turnosApp.personas
 # @description
 # # personas
 # Factory in the turnosApp.
###
personasSrv = ($rootScope, $resource, fechas) ->
    # Service logic
    personasAPI = $resource '/api/personas/:_id'
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
        eseDia = [ anno, mes, dia ]
        ultimoTurno = false # Si aún no había entrado, devolvemos false
        _.forEach persona.turnos, (turno) ->
          if not fechas.esAnterior eseDia, turno.alta
            ultimoTurno = turno.turno
          else
            return false
        return ultimoTurno

      # Devuelve la lista de personas que estaban de alta ese día en ese turno
      getPersonas: (turno, anno, mes, dia) ->
        getEstado = @getEstado
        getTurno = @getTurno
        _.filter personas, (persona) ->
          suEstado = getEstado persona, anno, mes, dia
          suTurno = getTurno persona, anno, mes, dia
          suTurno is turno and suEstado isnt 'B'

      # Devuelve nombre y apellidos de la persona 'id'
      getNombre: (id) ->
        persona = _.find personas, { _id: id }
        return persona.nombre + ' ' + persona.apellidos

      # Da de alta una nueva persona en la base de datos
      altaPersona: (nombre, apellidos, turno) ->
        persona = new personasAPI
          nombre: nombre
          apellidos: apellidos
          turnos: [{ turno: turno }]
          estados: [{ estado: 'A' }]
        persona.$save ->
          personas.push persona
          $rootScope.$broadcast 'ready'

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

      # Registra un alta en otro turno (cambio de grupo)
      nuevoTurno: (id, turno, fecha, done) ->
        if angular.isFunction fecha
          done = fecha
          fecha = null
        persona = _.find personas, { _id: id }
        if persona?
          datos = { turno: turno }
          datos.alta = fecha if fecha?
          turnosAPI.save { _idPersona: id }, datos, (data) ->
            persona.turnos.push data
            $rootScope.$broadcast 'ready'
            done?()
    }


angular.module 'andexApp'
  .factory 'personas', ['$rootScope', '$resource', 'fechas', personasSrv]
