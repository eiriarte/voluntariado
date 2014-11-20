'use strict'

describe 'Service: Auth', ->

  # load the service's module
  beforeEach module 'andexApp'

  # instantiate service
  Auth = undefined
  beforeEach inject (_Auth_) ->
    Auth = _Auth_

  it 'should do something', ->
    expect(!!Auth).toBe true