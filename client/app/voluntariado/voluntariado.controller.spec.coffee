'use strict'

describe 'Controller: VoluntariadoCtrl', ->

  # load the controller's module
  beforeEach module 'andexApp'
  VoluntariadoCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    VoluntariadoCtrl = $controller 'VoluntariadoCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
