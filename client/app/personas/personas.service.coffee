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
    personas = _.map andex_data.personas, (persona) -> new personasAPI persona
    delete andex_data.personas

    # Public API here
    {
      getPersonas: (turno) ->
        _.filter personas, (persona) ->
          persona.turno is turno and _.last(persona.estados).estado isnt 'B'

      getNombre: (id) ->
        persona = _.find personas, { _id: id }
        return persona.nombre + ' ' + persona.apellidos
      altaPersona: (nombre, apellidos, turno) ->
        persona = new personasAPI
          nombre: nombre
          apellidos: apellidos
          turno: turno
          estados: [{ estado: 'A', fecha: new Date() }]
        persona.$save ->
          personas.push persona
          $rootScope.$broadcast 'ready'
    }


angular.module 'andexApp'
  .factory 'personas', ['$rootScope', '$resource', personasSrv]
