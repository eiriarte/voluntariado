'use strict'

describe 'Filter: iconoasiste', ->

  # load the filter's module
  beforeEach module 'andexApp'

  # initialize a new instance of the filter before each test
  iconoasiste = undefined
  beforeEach inject ($filter) ->
    iconoasiste = $filter 'iconoasiste'

  it 'should return the input prefixed with \'iconoasiste filter:\'', ->
    text = 'angularjs'
    expect(iconoasiste text).toBe 'iconoasiste filter: ' + text
