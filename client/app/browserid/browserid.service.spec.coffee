'use strict'

describe 'Service: browserid', ->

  # load the service's module
  beforeEach module 'andexApp'

  # instantiate service
  browserid = undefined
  beforeEach inject (_browserid_) ->
    browserid = _browserid_

  it 'should do something', ->
    expect(!!browserid).toBe true