'use strict'

describe 'Service: turnos', ->

  # load the service's module
  beforeEach module 'andexApp'

  # instantiate service
  turnos = undefined
  beforeEach inject (_turnos_) ->
    turnos = _turnos_

  it 'should do something', ->
    expect(!!turnos).toBe true