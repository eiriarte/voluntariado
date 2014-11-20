'use strict'

describe 'Controller: SedeEditCtrl', ->

  # load the controller's module
  beforeEach module 'andexApp'
  SedeEditCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    SedeEditCtrl = $controller 'SedeEditCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
