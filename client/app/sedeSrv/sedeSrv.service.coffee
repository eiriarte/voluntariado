'use strict'

sedeSrv = ($resource, $log) ->

  # Service logic
  personasAPI = $resource '/api/admins/:_id', null, update: { method: 'PUT' }
  personas = _.map andex_data.sede, (persona) -> new personasAPI persona
  delete andex_data.sede

  # Public API here
  #
  # Devuelve la lista completa de personas de la sede
  getPersonas: -> personas

  # Devuelve la persona con _id = idPersona
  getPersona: (idPersona) ->
    _.find personas, { _id: idPersona }

  altaPersona: (datos, done) ->
    persona = new personasAPI datos
    persona.$save ->
      personas.push persona
      done null, persona
    , (httpResponse) ->
      $log.error 'Error HTTP: ', httpResponse
      done httpResponse

  modificarPersona: (datos, done) ->
    persona = @getPersona datos._id
    persona.nombre = datos.nombre
    persona.apellidos = datos.apellidos
    persona.$update { _id: persona._id }, ->
      done null, persona
    , (httpResponse) ->
      $log.error 'Error HTTP: ', httpResponse
      done httpResponse

angular.module 'andexApp'
.factory 'sedeSrv', [ '$resource', '$log', sedeSrv ]
