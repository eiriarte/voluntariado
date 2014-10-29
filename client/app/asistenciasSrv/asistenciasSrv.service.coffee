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

    # Desde qué mes/año tenemos los datos sincronizados (para estadísticas):
    syncDesdeMes = 99
    syncDesdeAnno = 9999

    # Devuelve true si tenemos los datos desde mes/anno en adelante
    sincronizado = (anno, mes) ->
      anno > syncDesdeAnno or anno is syncDesdeAnno and mes >= syncDesdeMes

    # Carga la caché de asistencias desde mes/anno en adelante
    syncAsistenciasDesde = (anno, mes, done) ->
      if not sincronizado anno, mes
        asistenciasAPI.query { desdeMes: mes, desdeAnno: anno }, (data) ->
          asistencias = []
          angular.forEach data, (asistencia) ->
            asAnno = asistencia.anno
            asMes = asistencia.mes
            asistencias[asAnno] = [] if not asistencias[asAnno]
            asistencias[asAnno][asMes] = [] if not asistencias[asAnno][asMes]
            asistencias[asAnno][asMes].push asistencia
          syncDesdeAnno = anno
          syncDesdeMes = mes
          done()
      else
        done()

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
          $log.debug asistencias
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

      # Completa el array fechas con el núm. de asistencias del turno idTurno
      getUltimosMeses: (fechas, idTurno, done) ->
        # Nos aseguramos de que tenemos los datos
        syncAsistenciasDesde fechas[0].anno, fechas[0].mes, ->
          # Tenemos los datos: completar el array
          angular.forEach fechas, (fecha) ->
            asisten = _.where asistencias[fecha.anno][fecha.mes],
              dia: fecha.dia
              turno: idTurno
              estado: 'si'
            fecha.numAsistencias = asisten.length
          # ¡Listo!
          done()

      getAsistenciasPersona: (num, persona, turno, done) ->
        estados =
          si: { texto: 'Asiste', si: true }
          no: { texto: 'No asiste', no: true }
          na: { texto: 'No avisa', na: true }
        susAsistencias = []
        # TODO: ¿y si ha tenido un cambio de grupo?: martes, martes, martes-jueves, jueves, jueves…
        # TODO: ¿y si ese año/mes/día el voluntario aún no estaba de alta???
        # Primer año/mes/día del turno correspondiente a la persona
        [ anno, mes ] = fechas.getHaceEneMeses num
        dia = fechas.getPrimer turno.dia, anno, mes
        $log.debug "Estadísticas de persona desde: #{dia}/#{mes}/#{anno}"
        # Nos aseguramos de que tenemos los datos
        syncAsistenciasDesde anno, mes, ->
          # Mientras sea un turno anterior a hoy
          while fechas.esAnterior [anno, mes, dia]
            # Buscamos su notificación para ese día
            asistencia = _.find asistencias[anno][mes],
              dia: dia
              persona: persona._id
              turno: turno._id
            # Si no la tiene, es un 'na' (No Avisa)
            estado = if asistencia then asistencia.estado else 'na'
            estado = angular.copy estados[estado]
            angular.extend estado, { anno: anno, mes: mes, dia: dia }
            susAsistencias.push estado
            # Turno siguiente
            [ anno, mes, dia ] = fechas.sumarSemanas [ anno, mes, dia ], 1
          $log.debug 'Notificaciones sin agrupar: ', susAsistencias
          # Agrupamos sus notificaciones por meses (posiblemente desordenados)
          susAsistencias = _.groupBy susAsistencias, (notif) ->
            fechas.getMesAnno notif.anno, notif.mes
          $log.debug 'Notificaciones agrupadas: ', susAsistencias
          # Pasamos susAsistencias al formato definitivo:
          susAsistencias = _.map susAsistencias, (notifs, mesAnno) ->
            mesAnno: mesAnno, notifs: notifs
          # Devolvemos los meses en orden cronológico inverso
          susAsistencias = _.sortBy susAsistencias, (mes) ->
            '' + mes.notifs[0].anno + ('0' + mes.notifs[0].mes).slice -2
          done susAsistencias.reverse()


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
