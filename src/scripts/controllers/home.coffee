angular.module('webApp')
  .controller 'HomeCtrl', [
    '$scope', '$state', 'projects'
    ($scope,   $state ,  projects) ->
      $scope.projects = projects
  ]
