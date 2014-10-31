'use strict'

voluntariadoCtrl = ($scope, $rootScope, $location, personas, turnos) ->
  $rootScope.seccion = 'sc-voluntariado'
  totales = personas.getTotalActivos()
  grupos = turnos.getTurnos()
  lista = personas.getLista()

  # Obtenemos los totales y activos de cada grupo y globalmente
  totalGlobal = 0
  activosGlobal = 0
  angular.forEach grupos, (grupo) ->
    totalTurno = totales[grupo._id].total
    activosTurno = totales[grupo._id].activos
    totalGlobal += totalTurno
    activosGlobal += activosTurno
    grupo.total = totalTurno
    grupo.activos = activosTurno

  tildes = 'á': 'a', 'é': 'e', 'í': 'i', 'ó': 'o', 'ú': 'u', 'Á': 'A', 'É': 'E', 'Í': 'I', 'Ó': 'O', 'Ú': 'U'
  tildesRE = /[áéíóúÁÉÍÓÚ]/g
  # Devuelve la cadena sustituyendo á por a, é por e, etc.
  $scope.sinTildes = (cadena) ->
    cadena.replace tildesRE, (letra) -> tildes[letra]

  # Asignamos nuevas propiedades a cada persona, para el filtro del typeahead
  angular.forEach lista, (persona) ->
    persona.nombreCompleto = persona.nombre + ' ' + persona.apellidos
    persona.nombreSinTildes = $scope.sinTildes persona.nombreCompleto

  # Cuando se selecciona una persona en el typeahead…
  $scope.seleccion = (persona) ->
    idTurno = _.last(persona.turnos).turno
    turno = turnos.getTurno(idTurno).slug
    url = "/voluntariado/#{turno}/vol/#{persona._id}"
    console.log url
    $location.path url

  # Datos para la vista
  $scope.voluntariado =
    busqueda: undefined
    lista: lista
    grupos: grupos
    total: totalGlobal
    activos: activosGlobal

angular.module 'andexApp'
  .controller 'VoluntariadoCtrl', [
    '$scope'
    '$rootScope'
    '$location'
    'personas'
    'turnos'
    voluntariadoCtrl
  ]
