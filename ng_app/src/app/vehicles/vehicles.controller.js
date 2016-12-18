(function() {
  'use strict';

  angular
    .module('ngApp')
    .controller('VehiclesController', VehiclesController);

  /** @ngInject */
  function VehiclesController($scope, Restangular, $log, $window, $state) {
    var vm = this

    vm.index = function(){
      Restangular.all('vehicles').getList().then(function(result) {
          vm.list = result
      },function(error) {
          $log.info(error.data.error_message)
          alert(error.data.error_message)
      });
    }

    vm.completeState = function(vehicle){
      var confirmRequest = $window.confirm('Are you sure you want to move the vehicle to the next state ');
      if(confirmRequest){
        Restangular.all('vehicles/' + vehicle.id + "/next_state").customPUT().then(function(result) {
          vehicle.state_name = result.vehicle.state_name
        },function(error) {
            $log.info(error)
            alert(error.data.message)
        });
      }
    }

    vm.goToAdmin = function(){
      $state.go("states")
    }
  }
})();
