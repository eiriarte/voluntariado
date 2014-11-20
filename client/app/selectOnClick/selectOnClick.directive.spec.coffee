'use strict'

describe 'Directive: selectOnClick', ->

  # load the directive's module
  beforeEach module 'andexApp'
  element = undefined
  scope = undefined
  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<select-on-click></select-on-click>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the selectOnClick directive'
