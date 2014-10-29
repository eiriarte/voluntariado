'use strict'

describe 'Controller: TurnoCtrl', ->

  # load the controller's module
  beforeEach module 'andexApp'
  TurnoCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    TurnoCtrl = $controller 'TurnoCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
