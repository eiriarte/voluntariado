'use strict'

describe 'Controller: ToastController', ->

  # load the controller's module
  beforeEach module 'andexApp'
  ToastCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ToastCtrl = $controller 'ToastController',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
