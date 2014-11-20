'use strict'

describe 'Controller: IdentCtrl', ->

  # load the controller's module
  beforeEach module 'andexApp'
  IdentCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    IdentCtrl = $controller 'IdentCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
