'use strict'

describe 'Filter: nombre', ->

  # load the filter's module
  beforeEach module 'andexApp'

  # initialize a new instance of the filter before each test
  nombre = undefined
  beforeEach inject ($filter) ->
    nombre = $filter 'nombre'

  it 'should return the input prefixed with \'nombre filter:\'', ->
    text = 'angularjs'
    expect(nombre text).toBe 'nombre filter: ' + text
