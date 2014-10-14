angular.module('webApp')
  .controller 'ProjectCtrl', [
    '$scope', 'Auth', 'project',
    ($scope,   Auth ,  project) ->
      $scope.project = project
  ]


