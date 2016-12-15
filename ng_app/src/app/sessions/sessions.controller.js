(function() {
  'use strict';

  angular
    .module('ngApp')
    .controller('SessionsController', SessionsController);

  /** @ngInject */
  function SessionsController($scope, Restangular, $log, AuthenticationService, $state) {
    var vm = this

    vm.handleSignIn = function(loginForm){
      $log.info(loginForm)
      Restangular.all('sessions').post(loginForm).then(function(result) {
          $log.info(result.message)
          AuthenticationService.SetCredentials(loginForm.email, loginForm.password);
          $state.go("home");
      },function(error) {
          $log.info(error.data.error_message)
          alert(error.data.error_message)
      });
    }
  }
})();
