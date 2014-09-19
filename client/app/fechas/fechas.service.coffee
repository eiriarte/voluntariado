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
        fecha = moment year: anno, month: mes - 1, day: dia
        fecha.format 'D/MMM/YYYY'
    }