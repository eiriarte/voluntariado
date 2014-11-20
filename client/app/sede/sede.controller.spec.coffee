'use strict'

describe 'Controller: SedeCtrl', ->

  # load the controller's module
  beforeEach module 'andexApp'
  SedeCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    SedeCtrl = $controller 'SedeCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
