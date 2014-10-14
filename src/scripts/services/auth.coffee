angular.module('webApp')
  .factory 'Auth', [
    'Tracker', '$q'
    (Tracker ,  $q) ->
      deferredUser = null

      logout: ->
        Tracker.setToken(null)
        deferredUser = null

      login: (token)->
        deferredUser = null
        Tracker.setToken(token)
        @currentUser()

      currentUser: ->
        return deferredUser if deferredUser
        deferredUser = Tracker.me()
          .then (response)->
            console.log response
            response.data
  ]
