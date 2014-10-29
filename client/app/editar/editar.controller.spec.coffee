'use strict'

describe 'Controller: EditarCtrl', ->

  # load the controller's module
  beforeEach module 'andexApp'
  EditarCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    EditarCtrl = $controller 'EditarCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
