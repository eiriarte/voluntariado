'use strict'

###*
 # @ngdoc service
 # @name turnosApp.personas
 # @description
 # # personas
 # Factory in the turnosApp.
###
angular.module 'andexApp'
  .factory 'personas', ->
    # Service logic
    # TODO: bootstrapping de estos datos y asignación a $resource 'personasRes'
    personas = [
      {
        _id: '18d497214f3c4f4e8e1f905e1eaf9207'
        nombre: 'Laura Luján León'
        turno: 'c1132a38efbb4d5da7261f0d0f855f8c'
        estados: [{ estado: 'A', fecha: new Date('2014-07-09T09:09:09.212Z') }, { estado: 'I', fecha: new Date('2014-08-09T09:09:09.212Z') }]
      },
      {
        _id: 'f5c354fd211d4af6bf46b7a1c6d70a3e'
        nombre: 'Leticia Leal López'
        turno: 'c1132a38efbb4d5da7261f0d0f855f8c'
        estados: [{ estado: 'A', fecha: new Date('2014-07-09T09:09:09.212Z') }]
      },
      {
        _id: 'c689cbf7a93c4480956c2e38850513bd'
        nombre: 'Lorena Losada Lozano'
        turno: 'c1132a38efbb4d5da7261f0d0f855f8c'
        estados: [{ estado: 'A', fecha: new Date('2014-07-09T09:09:09.212Z') }]
      },
      {
        _id: '96452ba42a4943f9bb01036aacb95128'
        nombre: 'Luz Luque Larrañaga'
        turno: 'c1132a38efbb4d5da7261f0d0f855f8c'
        estados: [{ estado: 'A', fecha: new Date('2014-07-09T09:09:09.212Z') }]
      },
      {
        _id: 'c9d55f9ee23546438c1a146657085ee3'
        nombre: 'María Márquez Muñoz'
        turno: 'fd2c047a079a4f698bb1af9307bff43d'
        estados: [{ estado: 'A', fecha: new Date('2014-07-09T09:09:09.212Z') }]
      },
      {
        _id: 'bf08f20cb08c4757b444fc14b55733ae'
        nombre: 'Macarena Machado Mata'
        turno: 'fd2c047a079a4f698bb1af9307bff43d'
        estados: [{ estado: 'A', fecha: new Date('2014-07-09T09:09:09.212Z') }]
      },
      {
        _id: 'ccf8d20b8eb44c02b5e04d4952fd0bfe'
        nombre: 'Marta Marín Mariscal'
        turno: 'fd2c047a079a4f698bb1af9307bff43d'
        estados: [{ estado: 'A', fecha: new Date('2014-07-09T09:09:09.212Z') }]
      },
      {
        _id: 'd3170f14b3b0480e9939cb3326ddc146'
        nombre: 'Magdalena Maqueda Murillo'
        turno: 'fd2c047a079a4f698bb1af9307bff43d'
        estados: [{ estado: 'A', fecha: new Date('2014-07-09T09:09:09.212Z') }]
      },
      {
        _id: '90f27467baa7485384ed7bf2ee7c7e19'
        nombre: 'Dolores Díaz Delgado'
        turno: '8ef5d7bdd85f4ad99cb41a186e598e94'
        estados: [{ estado: 'A', fecha: new Date('2014-07-09T09:09:09.212Z') }]
      },
      {
        _id: '40544311256c4adf8287507170b21a3b'
        nombre: 'Delia Dávila Domínguez'
        turno: '8ef5d7bdd85f4ad99cb41a186e598e94'
        estados: [{ estado: 'A', fecha: new Date('2014-07-09T09:09:09.212Z') }]
      },
      {
        _id: '2c2c29b3741145a4b2907fb5c504df09'
        nombre: 'Diana Dorantes Donato'
        turno: 'c1af0626dcca427bb87c2cad90d189e4'
        estados: [{ estado: 'A', fecha: new Date('2014-07-09T09:09:09.212Z') }]
      },
      {
        _id: '0de36f90c0b14e8594818dfadf40a031'
        nombre: 'Dorotea Díaz Díez'
        turno: 'c1af0626dcca427bb87c2cad90d189e4'
        estados: [{ estado: 'A', fecha: new Date('2014-07-09T09:09:09.212Z') }, { estado: 'B', fecha: new Date('2014-08-09T09:09:09.212Z') }]
      },
      {
        _id: '5707ed9dc3eb4b34bf93af69f002f7e7'
        nombre: 'Dalila Damas Dacosta'
        turno: 'c1af0626dcca427bb87c2cad90d189e4'
        estados: [{ estado: 'A', fecha: new Date('2014-07-09T09:09:09.212Z') }]
      }
    ]

    # Public API here
    {
      getPersonas: (turno) ->
        _.filter personas, (persona) ->
          persona.turno is turno and _.last(persona.estados).estado isnt 'B'

      getNombre: (id) ->
        persona = _.where personas, { _id: id }
        return persona[0].nombre
    }
