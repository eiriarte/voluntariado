'use strict'

authSrv = (personas) ->
  logado = false
  usuarioActual =
    _id: '5451f9f4f7d1a38379752313'
    persona: undefined #'5423e4d2eb6b682ad0996d90'
    sede: undefined #'545a03c523e5be3b15c7a29b'
    esAnonimo: -> logado and not @persona? and not @sede?
    esVoluntario: -> logado and @persona?
    esSede: -> logado and @sede?
    getIdTurno: -> @persona? and _.last(personas.getPersona(@persona).turnos).turno
    esCoordinador: -> @persona? and personas.getPersona(@persona).coord

  # Public API here
  logado: -> logado

  identificado: -> logado and not usuarioActual.esAnonimo()

  login: ->
    # ¿?: $window.location.href = …
    logado = true

  logout: ->
    # ¿?: $window.location.href = …
    logado = false

  getUsuarioActual: -> usuarioActual

angular.module 'andexApp'
  .factory 'auth', [ 'personas', authSrv ]
