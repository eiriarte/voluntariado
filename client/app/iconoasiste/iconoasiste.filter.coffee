'use strict'

###*
 # @ngdoc filter
 # @name turnosApp.filter:iconoasiste
 # @function
 # @description
 # # iconoasiste
 # Filter in the turnosApp.
###

filterIconoAsiste = ->
  iconos =
    si: '✔'
    no: '✘'
    na: '?'
  (asiste) -> iconos[asiste]

angular.module('andexApp')
  .filter 'iconoasiste', filterIconoAsiste
