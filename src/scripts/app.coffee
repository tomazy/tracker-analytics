angular.module 'webApp', ['ui.router', 'ngCookies', 'ui.bootstrap']
  .config [
    '$stateProvider', '$urlRouterProvider',
    ($stateProvider,   $urlRouterProvider) ->
      $stateProvider

        #// setup an abstract state for the tabs directive
        .state('login',
          url: "/login"
          controller: 'LoginCtrl'
          templateUrl: "templates/login.html"
          skipAuthentication: true
        )
        .state('home',
          url: ""
          templateUrl: "templates/home.html"
          controller: "HomeCtrl"
          resolve:
            projects: ['Auth', (Auth)-> Auth.currentUser().then (u)-> u.projects ]
        )
        .state('home.projects',
          url: '/projects'
          abstract: true
          template: '<ui-view/>'
        )
        .state('home.projects.show',
          url: '/:projectId'
          controller: 'ProjectCtrl'
          templateUrl: 'templates/project.html'
          resolve:
            project: [
              'projects', '$stateParams',
              (projects ,  $stateParams) ->

                for project in projects
                  return project if project.id == $stateParams.projectId

            ]
        )

      $urlRouterProvider.otherwise('/')
  ]

  .run [
    '$rootScope', '$state', 'Auth',
    ($rootScope ,  $state ,  Auth)->

      $rootScope.logout = ->
        Auth.logout()
        $state.go('login')

      $rootScope.$on '$stateChangeStart', (event, toState)->
        console.log toState

        redirectTo = (state)->
          $state.go(state)
          event.preventDefault()

        if toState.name == 'login'
          Auth.currentUser().then ->
            redirectTo 'home'
        else if not toState.skipAuthentication
          Auth.currentUser()
            .then (user)->
              $rootScope.currentUser = user
            .catch ->
              redirectTo 'login'
  ]
