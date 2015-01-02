'use strict'

sidebarCtrl = ($scope, $log, Auth, BrowserID) ->
  $scope.activa = false
  $scope.toggleSidebar = (activar)-> $scope.activa = activar
  $scope.logado = Auth.isLoggedIn
  $scope.esSede = -> Auth.esSede()
  $scope.esVoluntario = -> Auth.esVoluntario()
  $scope.nombre = -> Auth.nombre()
  $scope.enlacePerfil = ->
    if Auth.esSede()
      '/sede/usr/' + Auth.getCurrentUser().sede + '/editar'
    else
      '/voluntariado/' + Auth.turno().slug + '/vol/' + Auth.getCurrentUser().persona

  $scope.logout = ->
    if Auth.getCurrentUser().provider is 'browserid'
      $log.debug 'Identidad de BrowserID: .logout() de Persona'
      BrowserID.logout()
    else
      $log.debug 'Identidad de Facebook o Google: .logout vía token'
      Auth.logout()

angular.module 'andexApp'
  .controller 'SidebarCtrl', [
    '$scope'
    '$log'
    'Auth'
    'BrowserID'
    sidebarCtrl
  ]
