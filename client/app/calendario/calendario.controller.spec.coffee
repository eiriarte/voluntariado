'use strict'

describe 'Controller: CalendarioCtrl', ->

  # load the controller's module
  beforeEach module 'andexApp'
  CalendarioCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    CalendarioCtrl = $controller 'CalendarioCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
