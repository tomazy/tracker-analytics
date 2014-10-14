describe 'FriendsCtrl', ->
  beforeEach -> module 'webApp'

  $scope = null

  beforeEach inject ($controller, $rootScope) ->
   $scope = $rootScope.$new()

   $controller 'FriendsCtrl', $scope: $scope

  it 'sets the friends list in the scope', ->
    expect($scope.friends).to.exist
    expect($scope.friends).not.to.be.empty
