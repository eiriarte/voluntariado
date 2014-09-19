'use strict'

describe 'Controller: NuevovoluntarioCtrl', ->

  # load the controller's module
  beforeEach module 'andexApp'
  NuevovoluntarioCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    NuevovoluntarioCtrl = $controller 'NuevovoluntarioCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
