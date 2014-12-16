'use strict'

describe 'Service: url', ->

  # load the service's module
  beforeEach module 'andexApp'

  # instantiate service
  url = undefined
  beforeEach inject (_url_) ->
    url = _url_

  it 'should do something', ->
    expect(!!url).toBe true