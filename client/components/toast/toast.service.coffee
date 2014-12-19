'use strict'

toastSrv = ($timeout) ->
  messages = []

  removeMessage = (theMessage) ->
    angular.forEach messages, (message, index) ->
      messages.splice(index, 1) if message is theMessage

  addMessage = (message) ->
    message = {} if not angular.isObject message
    newMessage =
      type: if angular.isString(message.type) then message.type else 'info'
      text: if angular.isString(message.text) then message.text else '" "'
      timeout: if angular.isNumber(message.timeout) then message.timeout else 8000
      closable: angular.isUndefined(message.closable) or message.closable
    messages.unshift newMessage
    $timeout ->
      removeMessage newMessage
    ,
      newMessage.timeout

  # API Pública:
  # Devuelve la lista de mensajes
  getMessages: ->
    messages

  # Añade un nuevo mensaje a la lista
  add: (message) ->
    addMessage message

  # Elimina el mensaje de la lista
  remove: (message) ->
    removeMessage message

  # Añade un nuevo mensaje de información a la lista
  info: (text, timeout, closable) ->
    addMessage type: 'info', text: text, timeout: timeout, closable: closable

  # Añade un nuevo mensaje de éxito a la lista
  success: (text, timeout, closable) ->
    addMessage type: 'success', text: text, timeout: timeout, closable: closable

  # Añade un nuevo mensaje de error a la lista
  error: (text, timeout, closable) ->
    addMessage type: 'error', text: text, timeout: timeout, closable: closable

  # Añade un nuevo mensaje de aviso a la lista
  warning: (text, timeout, closable) ->
    addMessage type: 'warning', text: text, timeout: timeout, closable: closable


angular
  .module 'andexApp'
  .factory 'toast', [ '$timeout', toastSrv ]
