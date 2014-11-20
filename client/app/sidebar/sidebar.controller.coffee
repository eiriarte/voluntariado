'use strict'

sidebarCtrl = ($scope, auth) ->
  user = auth.getUsuarioActual()
  $scope.activa = false
  $scope.toggleSidebar = (activar)-> $scope.activa = activar
  $scope.logado = auth.logado
  $scope.esSede = -> user.esSede()
  $scope.esVoluntario = -> user.esVoluntario()
  $scope.esAnonimo = -> user.esAnonimo()

  # TODO: Provisional, seguramente bastará con las rutas /login y /logout
  $scope.login = auth.login
  $scope.logout = auth.logout

angular.module 'andexApp'
  .controller 'SidebarCtrl', [
    '$scope'
    'auth'
    sidebarCtrl
  ]
