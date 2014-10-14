angular.module('webApp')
  .controller 'FriendsCtrl', [
    '$scope', 'Friends',
    ($scope,   Friends) ->
      $scope.friends = Friends.all()
  ]
