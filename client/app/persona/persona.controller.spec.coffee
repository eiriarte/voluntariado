'use strict'

describe 'Controller: PersonaCtrl', ->

  # load the controller's module
  beforeEach module 'andexApp'
  PersonaCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PersonaCtrl = $controller 'PersonaCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
