'use strict'

describe 'Controller: NotificarCtrl', ->

  # load the controller's module
  beforeEach module 'andexApp'
  NotificarCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    NotificarCtrl = $controller 'NotificarCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
