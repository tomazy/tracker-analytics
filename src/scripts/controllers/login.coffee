angular.module('webApp')
  .controller 'LoginCtrl', [
    '$scope', '$state', 'Auth',
    ($scope,   $state ,  Auth) ->
      $scope.login = ->
        $scope.isSigningIn = true
        Auth.login($scope.token)
          .then ->
            $state.go('home')
          .catch (err)->
            console.log err
          .finally ->
            $scope.isSigningIn = false
  ]
