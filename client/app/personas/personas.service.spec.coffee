'use strict'

describe 'Service: personas', ->

  # load the service's module
  beforeEach module 'andexApp'

  # instantiate service
  personas = undefined
  beforeEach inject (_personas_) ->
    personas = _personas_

  it 'should do something', ->
    expect(!!personas).toBe true