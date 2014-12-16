'use strict'

browseridSrv = ($window, $http, Auth) ->

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
          .error ->
            $window.navigator.id.logout()
      onlogout: ->
        Auth.logout()

  request: ->
    $window.navigator.id?.request
      siteName: 'Voluntariado de ANDEX' #siteLogo: '/apple-touch-icon.png'

  logout: ->
    $window.navigator.id?.logout()

angular.module 'andexApp'
  .factory 'BrowserID', [ '$window', '$http', 'Auth', browseridSrv ]
