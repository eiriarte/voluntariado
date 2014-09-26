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
    turnos = andex_data.turnos
    delete andex_data.turnos

    # Public API here
    {
      # Devuelve 'm' si es turno de mañana, 't' si es de tarde, 'x' en otros casos
      getFranja: (idTurno) ->
        return turno.franja for turno in turnos when turno._id is idTurno
        return 'x'

      # Devuelve un array con el/los turno(s) de ese día de la semana [0-6]
      getTurnos: (diaSemana) ->
        if diaSemana?
          turno for turno in turnos when turno.dia is diaSemana
        else
          turnos

    }
