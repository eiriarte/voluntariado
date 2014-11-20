'use strict'

describe 'Service: sedeSrv', ->

  # load the service's module
  beforeEach module 'andexApp'

  # instantiate service
  sedeSrv = undefined
  beforeEach inject (_sedeSrv_) ->
    sedeSrv = _sedeSrv_

  it 'should do something', ->
    expect(!!sedeSrv).toBe true