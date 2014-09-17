'use strict'

describe 'Controller: AsistenciasCtrl', ->

  # load the controller's module
  beforeEach module 'andexApp'
  AsistenciasCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AsistenciasCtrl = $controller 'AsistenciasCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
