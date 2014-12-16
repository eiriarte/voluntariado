'use strict'

angular.module 'andexApp'
.config ($routeProvider) ->
  $routeProvider.when '/id/:codigo',
    templateUrl: 'app/ident/ident.html'
    controller: 'IdentCtrl'
  $routeProvider.when '/sede/id/:codigo',
    templateUrl: 'app/ident/ident.html'
    controller: 'IdentCtrl'
