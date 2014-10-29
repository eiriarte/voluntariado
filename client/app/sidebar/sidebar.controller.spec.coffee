'use strict'

describe 'Controller: SidebarCtrl', ->

  # load the controller's module
  beforeEach module 'andexApp'
  SidebarCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    SidebarCtrl = $controller 'SidebarCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
