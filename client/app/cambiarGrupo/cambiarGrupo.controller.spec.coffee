'use strict'

describe 'Controller: CambiargrupoCtrl', ->

  # load the controller's module
  beforeEach module 'andexApp'
  CambiargrupoCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    CambiargrupoCtrl = $controller 'CambiargrupoCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
