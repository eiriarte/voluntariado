'use strict'

sedeCtrl = ($scope, $rootScope, sede) ->
  $rootScope.seccion = 'sc-sede'
  $scope.sede =
    personas: sede.getPersonas()

angular.module 'andexApp'
  .controller 'SedeCtrl', ['$scope', '$rootScope', 'sedeSrv', sedeCtrl ]
