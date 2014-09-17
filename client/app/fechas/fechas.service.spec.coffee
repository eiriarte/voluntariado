'use strict'

describe 'Service: fechas', ->

  # load the service's module
  beforeEach module 'andexApp'

  # instantiate service
  fechas = undefined
  beforeEach inject (_fechas_) ->
    fechas = _fechas_

  it 'should do something', ->
    expect(!!fechas).toBe true