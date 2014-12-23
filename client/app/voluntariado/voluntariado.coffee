'use strict'

angular.module 'andexApp'
.config ($routeProvider) ->
  $routeProvider.when '/voluntariado',
    templateUrl: 'app/voluntariado/voluntariado.html'
    controller: 'VoluntariadoCtrl'
    authenticate: true
