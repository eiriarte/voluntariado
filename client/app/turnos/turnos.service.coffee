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
    # Incorporamos los datos de turnos cargados en el inicio
    turnos = andex_data.turnos
    delete andex_data.turnos
    # Calculamos los slug para las URL: "Sábado Tarde" -> "sábado-tarde"
    angular.forEach turnos, (turno) ->
      turno.slug = angular.lowercase turno.nombre.replace(/\s/g, '-')

    # Public API here
    {
      # Devuelve 'm' si es turno de mañana, 't' si es de tarde, 'x' en otros casos
      getFranja: (idTurno) ->
        return turno.franja for turno in turnos when turno._id is idTurno
        return 'x'

      # Devuelve el turno con _id = idTurno, o slug = idTurno si es un slug
      getTurno: (idTurno) ->
        if idTurno.length >= 24
          _.find turnos, { _id: idTurno }
        else
          _.find turnos, { slug: idTurno }

      # Devuelve un array con el/los turno(s) de ese día de la semana [0-6]
      getTurnos: (diaSemana) ->
        if diaSemana?
          turno for turno in turnos when turno.dia is diaSemana
        else
          turnos

    }
