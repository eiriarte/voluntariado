'use strict'

angular.module 'andexApp'
.config ($routeProvider) ->
  $routeProvider.when '/ayuda',
    templateUrl: 'app/ayuda/ayuda.html'
    controller: 'AyudaController'
