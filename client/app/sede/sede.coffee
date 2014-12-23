'use strict'

angular.module 'andexApp'
.config ($routeProvider) ->
  $routeProvider.when '/sede',
    templateUrl: 'app/sede/sede.html'
    controller: 'SedeCtrl'
    authenticate: true
