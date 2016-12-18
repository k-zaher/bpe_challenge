(function() {
  'use strict';

  angular
    .module('ngApp')
    .controller('MainController', MainController);

  /** @ngInject */
  function MainController($scope, $state, AuthenticationService) {
    var vm = this

    vm.logout = function(){
      AuthenticationService.ClearCredentials();
      $state.go("login");
    }
  }
})();
