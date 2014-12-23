'use strict'

angular.module 'andexApp'
.config ($routeProvider) ->
  $routeProvider.when '/voluntariado/:turno/vol/:persona',
    templateUrl: 'app/persona/persona.html'
    controller: 'PersonaCtrl'
    authenticate: true
