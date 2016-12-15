(function() {
  'use strict';

  angular
    .module('ngApp')
    .run(['$rootScope', '$location', '$cookies', '$http',
      function ($rootScope, $location, $cookies, $http) {
          // keep user logged in after page refresh
          if ($cookies.get('_authdata')) {
              $http.defaults.headers.common['Authorization'] = 'Basic ' + $cookies.get('_authdata');
          }else{
             $location.path('/login');
          }
      }]);

})();
