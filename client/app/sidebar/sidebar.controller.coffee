'use strict'

sidebarCtrl = ($scope) ->
  $scope.activa = false
  $scope.toggleSidebar = (activar)-> $scope.activa = activar

angular.module 'andexApp'
  .controller 'SidebarCtrl', ['$scope', sidebarCtrl]
