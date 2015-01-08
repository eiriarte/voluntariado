'use strict'

angular.module 'andexApp'
.factory 'url', ($location) ->
  return (thePath) ->
    protocol = $location.protocol() + '://'
    host = $location.host()
    port = if $location.port() not in ['', 80, 443] then ':' + $location.port() else ''
    path = if thePath? then thePath else ''

    protocol + host + port + path

