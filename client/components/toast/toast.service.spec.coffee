'use strict'

describe 'Service: toast', ->

  # load the service's module
  beforeEach module 'toastestApp'

  # instantiate service
  toast = undefined
  beforeEach inject (_toast_) ->
    toast = _toast_

  it 'should do something', ->
    expect(!!toast).toBe true