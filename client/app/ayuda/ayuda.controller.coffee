'use strict'

ayudaCtrl = ($rootScope) ->
  $rootScope.seccion = 'sc-ayuda'

angular
  .module 'andexApp'
  .controller 'AyudaController', [ '$rootScope', ayudaCtrl ]
