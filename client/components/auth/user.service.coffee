'use strict'

angular.module 'andexApp'
.factory 'User', ($resource) ->
  $resource '/api/users/:id',
    id: '@_id'
  ,
    get:
      method: 'GET'
      params:
        id: 'me'

