'use strict'

authSrv = (User, $log, $window, $timeout, $cookieStore, personas, turnos, sedeSrv) ->
  # TODO: usuario sede no puede dar altas de voluntarios!!!
  #currentUser = _id: '5451f9f4f7d1a38379752313', sede: '545a03c523e5be3b15c7a29b', persona: undefined #'5423e4d2eb6b682ad0996d90'
  if $cookieStore.get 'token'
    $log.debug 'Token presente: obteniendo usuario'
    currentUser = User.get()
  else
    $log.debug 'Token no presente: sesión anónima'
    currentUser = {}

  ###
  Delete access token and user info

  @param  {Function}
  ###
  logout: ->
    $log.debug 'Eliminando token de autenticación…'
    $cookieStore.remove 'token'
    currentUser = {}
    $timeout -> $window.location.href = '/'


  ###
  Gets all available info on authenticated user

  @return {Object} user
  ###
  getCurrentUser: ->
    currentUser


  ###
  Check if a user is logged in synchronously

  @return {Boolean}
  ###
  isLoggedIn: ->
    currentUser.hasOwnProperty '_id'


  ###
  Waits for currentUser to resolve before checking if user is logged in
  ###
  isLoggedInAsync: (callback) ->
    if currentUser.hasOwnProperty '$promise'
      currentUser.$promise.then ->
        callback? true
        return
      .catch ->
        callback? false
        return

    else
      callback? currentUser.hasOwnProperty '_id'


  ###
  Devuelve el ID de voluntario

  @return {Boolean}
  ###
  persona: ->
    currentUser.persona


  ###
  Devuelve el nombre del voluntario o persona de la sede
  ###
  nombre: ->
    if currentUser.persona?
      personas.getPersona(currentUser.persona).nombre
    else if currentUser.sede?
      sedeSrv.getPersona(currentUser.sede).nombre
    else
      ''


  ###
  Devuelve el nombre del turno de la persona
  ###
  turno: ->
    if currentUser.persona?
      turnos.getTurno personas.getTurno(currentUser.persona)
    else
      ''


  ###
  Comprueba si es un usuario aún no identificado

  @return {Boolean}
  ###
  esVoluntario: ->
    currentUser._id and currentUser.persona?


  ###
  Comprueba si es un usuario aún no identificado

  @return {Boolean}
  ###
  # TODO: no sirve, eliminar
  esAnonimo: ->
    currentUser._id and not currentUser.persona? and not currentUser.sede?


  ###
  Comprueba si es un usuario identificado

  @return {Boolean}
  ###
  # TODO: no sirve, eliminar
  identificado: ->
    not @esAnonimo


  ###
  Comprueba si es un usuario de la sede

  @return {Boolean}
  ###
  esSede: ->
    currentUser._id? and currentUser.sede?


  ###
  Comprueba si es un voluntario coordinador/a

  @return {Boolean}
  ###
  esCoordinador: ->
    currentUser.persona? and personas.getPersona(currentUser.persona).coord


  ###
  Devuelve el ID del turno del usuario

  @return {String}
  ###
  getIdTurno: ->
    currentUser.persona? and _.last(personas.getPersona(currentUser.persona).turnos).turno


  ###
  Get auth token
  ###
  getToken: ->
    $cookieStore.get 'token'


angular
  .module 'andexApp'
  .factory 'Auth', [
    'User'
    '$log'
    '$window'
    '$timeout'
    '$cookieStore'
    'personas'
    'turnos'
    'sedeSrv'
    authSrv
  ]
