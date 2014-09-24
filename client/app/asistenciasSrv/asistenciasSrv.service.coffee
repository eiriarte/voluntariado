'use strict'

###*
 # @ngdoc service
 # @name turnosApp.asistencias
 # @description
 # # asistencias
 # Factory in the turnosApp.
###

factoryAsistencias = ($log, $rootScope, $resource, fechas, turnos, personas) ->
    # Service logic
    asistenciasAPI = $resource '/api/asistencias/:_id'
    asistencias = []
    nivelesAsistencia = [ 'nadie', 'pocos', 'alguno', 'alguno', 'muchos' ]

    getNivel = (asistencias) ->
      nivel = nivelesAsistencia[asistencias]
      nivel ? 'muchos'

    # Devuelve el estado de la asistencia en función del del voluntario ese día
    getEstadoPorDefecto = (persona, anno, mes, dia) ->
      estado = personas.getEstado persona, anno, mes, dia
      # Si esta(ba) inactivo, por defecto es ausencia notificada
      return if estado is 'I' then 'no' else 'na'

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

        # Todas las personas asignadas a ese turno ese día
        noconfirmadas = personas.getPersonas turno, anno, mes, dia
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
            estado: getEstadoPorDefecto persona, anno, mes, dia
          }

        # Concatenamos los dos arrays y devolvemos
        return confirmadas.concat noconfirmadas

      # Elimina una notificación de asistencia (falta sin avisar)
      eliminar: (asistencia, done) ->
        asistencia.$delete { _id: asistencia._id }, ->
          delete asistencia._id
          asistencia.estado = 'na'
          # La eliminamos del array
          _.remove asistencias[asistencia.anno][asistencia.mes], _id: asistencia._id
          # Notificamos el cambio al calendario
          $rootScope.$broadcast 'asistencia', asistencia.dia
          done()

      # Inserta o modifica una notificación de asistencia / ausencia
      guardar: (asistencia, opcion, done) ->
        asistencia.estado = opcion
        nueva = not asistencia._id
        asistencia.$save (data) ->
          # Añadir al calendario si es nueva
          asistencias[data.anno][data.mes].push data if nueva
          # Notificamos el cambio al calendario
          $rootScope.$broadcast 'asistencia', data.dia
          # Si se ha notificado asistencia y está Inactivo
          if opcion is 'si'
            estado = personas.getEstado asistencia.persona, asistencia.anno, asistencia.mes, asistencia.dia
            if estado is 'I'
              # Volver a poner Activo en esa fecha
              fecha = new Date asistencia.anno, asistencia.mes - 1, asistencia.dia
              personas.nuevoEstado asistencia.persona, 'A', fecha
          done()
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
