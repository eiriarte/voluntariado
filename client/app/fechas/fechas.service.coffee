'use strict'

###*
 # @ngdoc service
 # @name turnosApp.fechas
 # @description
 # # fechas
 # Factory in the turnosApp.
###
angular.module 'andexApp'
  .factory 'fechas', ->

    # Devuelve un array con los últimos días del mes anterior
    getMesAnterior = (esteMes) ->
      diaSemana = esteMes.weekday()
      if diaSemana is 0
        # El primer día del mes es lunes, no hay días del mes anterior
        return []
      else
        anterior = esteMes.clone()
        # Último día del mes anterior
        ultimo = anterior.subtract(1, 'day').date()
        # Calculamos en qué cae el lunes
        lunes = ultimo - diaSemana + 1
        # Devolvemos el array [lunes..ultimo]
        delMes: dia, fecha: new Date(anterior.year(), anterior.month(), dia), asistencias: 'otro-mes' for dia in [lunes..ultimo]


    # Devuelve un array con los primeros días del mes siguiente
    getMesSiguiente = (esteMes) ->
      ultimoMes = esteMes.clone().endOf('month')
      diaSemana = ultimoMes.weekday()
      if diaSemana is 6
        # El último día del mes cae en domingo, no hay días del mes siguiente
        return []
      else
        # Calculamos el número de días del mes siguiente a devolver
        numDias = 6 - diaSemana
        # Devolvemos el array [1..numDias]
        ultimoMes.add(1, 'day')
        delMes: dia, fecha: new Date(ultimoMes.year(), ultimoMes.month(), dia), asistencias: 'otro-mes' for dia in [1..numDias]

    # Devuelve un moment del primer día del mes de hace num meses
    haceEneMeses = (num) ->
      limite = moment(new Date(andex_data.hoy))
      limite.startOf('month').subtract num, 'month'

    # Public API here
    {
      # Devuelve un array con los días a mostrar en el calendario
      getCalendario: (anno, mes) ->
        diaUno = moment year: anno, month: mes - 1
        # Días del mes anterior
        calendario = getMesAnterior diaUno
        # Días de este mes
        esteMes = (delMes: dia, fecha: new Date(anno, mes - 1, dia) for dia in [1..diaUno.daysInMonth()])
        calendario = calendario.concat esteMes
        # Días del mes siguiente
        calendario = calendario.concat getMesSiguiente(diaUno)
        # Dividir en subarrays de siete elementos (semanas)
        calendario[i..i+6] for i in [0..calendario.length - 1] by 7

      # Devuelve un array con el año, mes y día del primero del mes de hace num meses
      getHaceEneMeses: (num) ->
        fecha = haceEneMeses num
        [ fecha.year(), fecha.month() + 1, 1 ]

      # Devuelve la fecha más numDias días
      sumarDias: (fecha, numDias) ->
        fecha = moment([ fecha[0], fecha[1] - 1, fecha[2] ]).add numDias, 'day'
        [ fecha.year(), fecha.month() + 1, fecha.date() ]

      # Obtiene un array de los turnos de ese día de la semana, desde los num
      # meses anteriores
      getUltimosMeses: (num, diaSemana) ->
        array = []
        fecha = moment(new Date(andex_data.hoy)).subtract 1, 'day'
        fecha.subtract(1, 'day') until fecha.weekday() is diaSemana
        limite = haceEneMeses num
        until fecha.isBefore limite, 'day'
          turno =
            dia: fecha.date()
            mes: fecha.month() + 1
            anno: fecha.year()
            fecha: fecha.format 'D [de] MMMM'
            primeroDelMes: fecha.date() <= 7
          array.push turno
          fecha.subtract 1, 'week'
        array.reverse()

      getMesAnno: (anno, mes) ->
        fecha = moment year: anno, month: mes - 1
        mesAnno = fecha.format 'MMMM [de] YYYY'
        mesAnno.charAt(0).toUpperCase() + mesAnno.slice(1)

      getDiaSemana: (anno, mes, dia) ->
        fecha = moment year: anno, month: mes - 1, day: dia
        fecha.weekday()

      getDiaSemCorto: (anno, mes, dia) ->
        fecha = moment year: anno, month: mes - 1, day: dia
        diaSemana = fecha.format 'ddd'
        diaSemana.charAt(0).toUpperCase() + diaSemana.slice(1)

      esFinde: (anno, mes, dia) ->
        @getDiaSemana(anno, mes, dia) in [5, 6]

      getFechaLegible: (anno, mes, dia) ->
        if anno and mes and dia
          fecha = moment year: anno, month: mes - 1, day: dia
          fecha.format 'D/MMM/YYYY'
        else if anno
          fecha = moment anno
          fecha.format 'LL'


      esAnterior: (fecha1, fecha2) ->
        if angular.isArray fecha1
          fecha1 = angular.copy(fecha1)
          fecha1[1] = fecha1[1] - 1
        fecha1 = moment fecha1
        if fecha2?
          if angular.isArray fecha2
            fecha2 = angular.copy(fecha2)
            fecha2[1] = fecha2[1] - 1
          fecha2 = moment fecha2
        else
          fecha2 = moment(new Date(andex_data.hoy))
        return fecha1.isBefore fecha2, 'day'

      esHoy: (dia) -> moment(new Date(andex_data.hoy)).isSame dia, 'day'

      esFechaValida: (anno, mes, dia) ->
        fecha = moment year: anno, month: mes - 1, day: dia
        fecha.isValid() and anno > 1900 and anno < 2200
    }
