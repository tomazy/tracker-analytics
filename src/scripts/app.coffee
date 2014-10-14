angular.module 'webApp', ['ui.router']
  .config [
    '$stateProvider', '$urlRouterProvider',
    ($stateProvider,   $urlRouterProvider) ->
      $stateProvider

        #// setup an abstract state for the tabs directive
        .state('home',
          url: "/",
          controller: 'FriendsCtrl',
          templateUrl: "templates/friends.html"
        )

      $urlRouterProvider.otherwise('/')
  ]
