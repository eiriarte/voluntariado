'use strict'

###*
 # @ngdoc service
 # @name turnosApp.asistencias
 # @description
 # # asistencias
 # Factory in the turnosApp.
###

factoryAsistencias = ($log, $rootScope, $resource, fechas, turnos, personas) ->
    # TODO: nueva incorporación aparece "no confirmada" en fechas anteriores???
    # Service logic
    asistenciasAPI = $resource('/api/asistencias/:_id')
    asistencias = []
    nivelesAsistencia = [ 'nadie', 'pocos', 'alguno', 'alguno', 'muchos']

    getNivel = (asistencias) ->
      nivel = nivelesAsistencia[asistencias]
      nivel ? 'muchos'

    getEstadoPorDefecto = (estados) ->
      ultimoEstado = _.last(estados.estado)
      return if ultimoEstado is 'I' then 'no' else 'na'

    # Public API here
    {
      # Carga las asistencias del mes en asistencias[anno][mes]
      syncAsistencias: (anno, mes) ->
        # ¿Ya teníamos este mes?
        if asistencias[anno] and asistencias[anno][mes]
          $rootScope.$broadcast 'ready'
        else asistenciasAPI.query { anno: anno, mes: mes }, (data) ->
          $log.debug 'sync ready!!!'
          asistencias[anno] = [] if not asistencias[anno]
          asistencias[anno][mes] = data
          $rootScope.$broadcast 'ready'
        , (httpResponse) ->
          $log.debug 'sync error!!!'

      # Devuelve los niveles de asistencia del día en una cadena: "t-pocos m-muchos", etc.
      getNiveles: (anno, mes, dia) ->
        return '' if not asistencias[anno] or not asistencias[anno][mes]
        mannana = 0
        tarde = 0
        for asistencia in asistencias[anno][mes]
          if asistencia.dia is dia and asistencia.estado is 'si'
            if turnos.getFranja(asistencia.turno) is 't'
              tarde += 1
            else
              mannana += 1
        niveles = 't-' + getNivel(tarde)
        niveles += ' m-' + getNivel(mannana) if fechas.esFinde anno, mes, dia
        return niveles

      # Devuelve un array con las asistencias, confirmadas o no, del día y turno
      getAsistencias: (anno, mes, dia, turno) ->
        # Personas con asistencia/ausencia confirmada ese día y turno
        confirmadas = _.where asistencias[anno][mes], { dia: dia, turno: turno }

        # Todas las personas asignadas a ese turno
        noconfirmadas = personas.getPersonas turno
        # Excluimos a las que tienen alguna confirmación de asistencia/ausencia
        noconfirmadas = _.reject noconfirmadas, (noconfirmada) ->
          return _.some confirmadas, { persona: noconfirmada._id }
        noconfirmadas = _.map noconfirmadas, (persona) ->
          return new asistenciasAPI {
            anno: anno
            mes: mes
            dia: dia
            turno: turno
            persona: persona._id
            estado: getEstadoPorDefecto(persona.estados)
          }

        # Concatenamos los dos arrays y devolvemos
        return confirmadas.concat noconfirmadas

      # Elimina una notificación de asistencia (falta sin avisar)
      eliminar: (asistencia) ->
        asistencia.$delete { _id: asistencia._id }, ->
          delete asistencia._id
          asistencia.estado = 'na'
          # La eliminamos del array
          _.remove asistencias[asistencia.anno][asistencia.mes], _id: asistencia._id
          # Notificamos el cambio al calendario
          $rootScope.$broadcast 'asistencia', asistencia.dia

      # Inserta o modifica una notificación de asistencia / ausencia
      guardar: (asistencia, opcion) ->
        asistencia.estado = opcion
        nueva = not asistencia.id
        asistencia.$save (data) ->
          # Añadir al calendario si es nueva
          asistencias[data.anno][data.mes].push data if nueva
          # Notificamos el cambio al calendario
          $rootScope.$broadcast 'asistencia', data.dia
    }

angular.module('andexApp').
  factory 'asistenciasSrv', [
    '$log'
    '$rootScope'
    '$resource'
    'fechas'
    'turnos'
    'personas'
    factoryAsistencias
  ]
