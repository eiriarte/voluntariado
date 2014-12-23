'use strict'

describe 'Controller: AyudaCtrl', ->

  # load the controller's module
  beforeEach module 'andexApp'
  AyudaCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AyudaCtrl = $controller 'AyudaCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
