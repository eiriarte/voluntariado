'use strict'

browseridSrv = ($window, $http, $log, Auth, toast) ->

  watch: (user) ->
    $window.navigator.id?.watch
      loggedInUser: user
      onlogin: (assertion) ->
        datos = { assertion: assertion }
        datos.vid = andex_data.identificacion?.vid
        datos.sid = andex_data.identificacion?.sid
        $http.post '/auth/browserid', datos
          .success ->
            $window.location.href= '/'
          .error (data, status) ->
            $log.debug "Error de autenticación BrowserID. DATA: #{data}, STATUS: #{status}"
            toast.error 'Parece que ha habido algún problema con la identificación :('
            $window.navigator.id.logout()
      onlogout: ->
        Auth.logout()

  request: ->
    $window.navigator.id?.request
      siteName: 'Voluntariado de ANDEX' #siteLogo: '/apple-touch-icon.png'
      termsOfService: '/ayuda'
      privacyPolicy: '/ayuda'
      oncancel: ->
        $log.debug 'Login cancelado.'
        toast.error 'Lo siento, no te hemos podido identificar. ¿Lo intentas otra vez?'

  logout: ->
    $window.navigator.id?.logout()

angular.module 'andexApp'
  .factory 'BrowserID', [
    '$window'
    '$http'
    '$log'
    'Auth'
    'toast'
    browseridSrv
  ]
