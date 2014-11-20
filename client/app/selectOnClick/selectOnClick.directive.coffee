'use strict'

angular.module 'andexApp'
  .directive 'selectOnClick', ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      element.on 'click', ->
        @select()
        @setSelectionRange?(0, 9999)
