(function() {
  'use strict';

  angular
    .module('ngApp')
    .config(routerConfig);

  /** @ngInject */
  function routerConfig($stateProvider, $urlRouterProvider) {
    $stateProvider
      .state('login', {
        url: '/login',
        templateUrl: 'app/sessions/login.html',
        controller: 'SessionsController',
        controllerAs: 'sessions'
      })
      .state('home', {
        url: '/',
        templateUrl: 'app/vehicles/index.html',
        controller: 'VehiclesController',
        controllerAs: 'vehicles'
      })
      .state('states', {
        url: '/states',
        templateUrl: 'app/states/index.html',
        controller: 'StatesController',
        controllerAs: 'states'
      });

    $urlRouterProvider.otherwise('/');
  }

})();
