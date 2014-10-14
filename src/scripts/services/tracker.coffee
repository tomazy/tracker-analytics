angular.module('webApp')
  .factory 'Tracker', [
    '$cookies', '$http', '$q',
    ($cookies ,  $http ,  $q) ->

      getToken = ->
        deferred = $q.defer()
        if $cookies.trackerToken
          deferred.resolve $cookies.trackerToken
        else
          deferred.reject 'Invalid token'

        deferred.promise

      API_ENDPOINT = "https://www.pivotaltracker.com/services/v5"

      get = (path, params)->
        getToken().then (token)->
          $http.get "#{API_ENDPOINT}#{path}", {
            params: params
            headers:
              'X-TrackerToken': token
          }

      setToken: (token)->
        $cookies.trackerToken = token

      me: ->
        get '/me'
  ]




