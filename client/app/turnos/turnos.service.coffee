'use strict'

###*
 # @ngdoc service
 # @name turnosApp.turnos
 # @description
 # # turnos
 # Factory in the turnosApp.
###
angular.module 'andexApp'
  .factory 'turnos', ->
    # Service logic
    # TODO: bootstrapping de estos datos y asignación a $resource 'turnos'
    turnos = [
      {
        _id: 'c1132a38efbb4d5da7261f0d0f855f8c',
        nombre: 'Lunes',
        dia: 0,
        activo: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        franja: 't',
        entrada: '18:00',
        salida: '20:00'
      },
      {
        _id: 'fd2c047a079a4f698bb1af9307bff43d',
        nombre: 'Martes',
        dia: 1,
        activo: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        franja: 't',
        entrada: '18:00',
        salida: '20:00'
      },
      {
        _id: 'c426dabbfd0544b49b8288304cefe36a',
        nombre: 'Miércoles',
        dia: 2,
        activo: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        franja: 't',
        entrada: '18:00',
        salida: '20:00'
      },
      {
        _id: '1bd615524656479296538b26566a629a',
        nombre: 'Jueves',
        dia: 3,
        activo: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        franja: 't',
        entrada: '18:00',
        salida: '20:00'
      },
      {
        _id: '4e8abdee1c134bce806c736ab0587c6b',
        nombre: 'Viernes',
        dia: 4,
        activo: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        franja: 't',
        entrada: '18:00',
        salida: '20:00'
      },
      {
        _id: '7ea60509a65d41a891de5e65ce1dc89e',
        nombre: 'Sábado Mañana',
        dia: 5,
        activo: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        franja: 'm',
        entrada: '11:00',
        salida: '13:00'
      },
      {
        _id: '78e0d5448c3e43e4803ed380ab67b4e6',
        nombre: 'Sábado Tarde',
        dia: 5,
        activo: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        franja: 't',
        entrada: '18:00',
        salida: '20:00'
      },
      {
        _id: '8ef5d7bdd85f4ad99cb41a186e598e94',
        nombre: 'Domingo Mañana',
        dia: 6,
        activo: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        franja: 'm',
        entrada: '11:00',
        salida: '13:00'
      },
      {
        _id: 'c1af0626dcca427bb87c2cad90d189e4',
        nombre: 'Domingo Tarde',
        dia: 6,
        activo: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        franja: 't',
        entrada: '18:00',
        salida: '20:00'
      }
    ]

    # Public API here
    {
      # Devuelve 'm' si es turno de mañana, 't' si es de tarde, 'x' en otros casos
      getFranja: (idTurno) ->
        return turno.franja for turno in turnos when turno._id is idTurno
        return 'x'

      # Devuelve un array con el/los turno(s) de ese día de la semana [0-6]
      getTurnos: (diaSemana) ->
        turno for turno in turnos when turno.dia is diaSemana

    }
