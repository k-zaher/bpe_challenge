(function() {
  'use strict';

  angular
    .module('ngApp')
    .controller('StatesController', StatesController);

  /** @ngInject */
  function StatesController($scope, Restangular, $log, $window, $state) {
    var vm = this

    vm.orderUpdated = false
    vm.editForm = false
    vm.logMessage = ""

    vm.sortableOptions = {
       update: function(e, ui) {
        vm.orderUpdated = true
        $scope.$apply();
       }
    }

    vm.goToHome = function(){
      $state.go("home")
    }
    vm.showEditForm = function(state){
      vm.editForm = state
    }

    vm.index = function(){
      Restangular.all('states').customGET().then(function(result) {
          vm.list = result.states_list
      },function(error) {
          $log.info(error.data.error_message)
          alert(error.data.message)
          $state.go("home")
      });
    }

    vm.create = function(stateForm){
      Restangular.all('states').post(stateForm).then(function(result) {
          alert(stateForm.name + " Added Successfully")
          vm.list.push(result.state)
      },function(error) {
          $log.info(error.data.error_message)
          alert(error.data.error_message)
      });
    }

    vm.update = function(stateForm){
      Restangular.all('states/' + stateForm.id).customPUT({state: stateForm}).then(function(result) {
          alert(stateForm.name + " Update Successfully")
      },function(error) {
          $log.info(error.data.error_message)
          alert(error.data.error_message)
      });
    }

    vm.delete = function(stateItem, index){
      if(stateItem.vehicles_count > 0){
        alert("Please remove vehicles from " + stateItem.name + " state first!")
      }else{
        var confirmRequest = $window.confirm('Are you sure you want to delete ' + stateItem.name + " ?")
        if(confirmRequest){
          Restangular.one('states/' + stateItem.id).remove().then(function(result) {
              alert(stateItem.name + " Deleted Successfully")
              vm.list.splice(index, 1)
          },function(error) {
              $log.info(error.data.error_message)
              alert(error.data.error_message)
          });
        }
      }
    }

    vm.updateOrder = function(){
      var sortedHash = {}
      angular.forEach(vm.list,function(obj,index){
        sortedHash[obj.id] = index
      })
      Restangular.all('states/update_order').customPUT({sorted_states: sortedHash}).then(function(result) {
        alert("States order updated Successfully")
        vm.orderUpdated = false
      },function(error) {
          $log.info(error)
          alert(error.data.message[0])
      });
    }
  }
})();
