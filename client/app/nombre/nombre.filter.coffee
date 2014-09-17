'use strict'

###*
 # @ngdoc filter
 # @name turnosApp.filter:nombre
 # @function
 # @description Devuelve el nombre de la persona con ese ID
 # # nombre
 # Filter in the turnosApp.
###

filterNombre = (personas) ->
  (id) ->
    personas.getNombre id

angular.module('andexApp')
  .filter 'nombre', ['personas', filterNombre]
