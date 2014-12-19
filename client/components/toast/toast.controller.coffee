'use strict'

toastCtrl = ($scope, toast) ->
  $scope.messages = toast.getMessages()

  $scope.close = (message) ->
    toast.remove message


angular
  .module 'andexApp'
  .controller 'ToastController', [ '$scope', 'toast', toastCtrl ]
