'use strict'

describe 'Service: asistenciasSrv', ->

  # load the service's module
  beforeEach module 'andexApp'

  # instantiate service
  asistenciasSrv = undefined
  beforeEach inject (_asistenciasSrv_) ->
    asistenciasSrv = _asistenciasSrv_

  it 'should do something', ->
    expect(!!asistenciasSrv).toBe true