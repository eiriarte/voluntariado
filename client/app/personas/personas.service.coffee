'use strict'

###*
 # @ngdoc service
 # @name turnosApp.personas
 # @description
 # # personas
 # Factory in the turnosApp.
###
personasSrv = ($rootScope, $resource) ->
    # Service logic
    personasAPI = $resource '/api/personas/:_id'
    estadosAPI = $resource '/api/personas/:_idPersona/estados/:_idEstado'
    personas = _.map andex_data.personas, (persona) -> new personasAPI persona
    delete andex_data.personas

    # Public API here
    {
      # Devuelve el estado de la persona ese día
      getEstado: (persona, anno, mes, dia) ->
        if angular.isString persona
          persona = _.find personas, { _id: persona }
        ahora = new Date anno, mes - 1, dia
        ultimoEstado = 'B' # Si aún no había entrado, devolvemos "Baja"
        _.forEach persona.estados, (estado) ->
          entonces = new Date estado.fecha
          # Quitamos la hora para poder comparar sólo dd/mm/aaaa
          entonces = new Date entonces.toDateString()
          if entonces <= ahora
            ultimoEstado = estado.estado
          else
            return false
        return ultimoEstado

      # Devuelve la lista de personas del grupo 'turno' que estaban de alta ese día
      getPersonas: (turno, anno, mes, dia) ->
        getEstado = @getEstado
        _.filter personas, (persona) ->
          persona.turno is turno and getEstado(persona, anno, mes, dia) isnt 'B'

      # Devuelve nombre y apellidos de la persona 'id'
      getNombre: (id) ->
        persona = _.find personas, { _id: id }
        return persona.nombre + ' ' + persona.apellidos

      # Da de alta una nueva persona en la base de datos
      altaPersona: (nombre, apellidos, turno) ->
        persona = new personasAPI
          nombre: nombre
          apellidos: apellidos
          turno: turno
          estados: [{ estado: 'A', fecha: new Date() }]
        persona.$save ->
          personas.push persona
          $rootScope.$broadcast 'ready'

      # Registra un nuevo estado de la persona (Alta, Baja, Inactivo…)
      nuevoEstado: (id, estado) ->
        persona = _.find personas, { _id: id }
        if persona?
          estadosAPI.save { _idPersona: id }, { estado: estado }, (data) ->
            persona.estados.push data
            $rootScope.$broadcast 'ready'
    }


angular.module 'andexApp'
  .factory 'personas', ['$rootScope', '$resource', personasSrv]
