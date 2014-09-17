'use strict'

describe 'Controller: AsistenciaCtrl', ->

  # load the controller's module
  beforeEach module 'andexApp'
  AsistenciaCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AsistenciaCtrl = $controller 'AsistenciaCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
